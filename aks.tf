data "azurerm_key_vault_secret" "ssh_key" {
  name         = "kwal-sshkey"
  key_vault_id = "/subscriptions/76d297a0-2ef7-4a66-ab11-8818b709cd09/resourceGroups/prod-kwal-tfstate-rg/providers/Microsoft.KeyVault/vaults/kwalkeyvault01"
}

# There are two types of managed idetities "System assigned" & "UserAssigned". User-assigned managed identities can be used on multiple resources.
resource "azurerm_user_assigned_identity" "identity" {
  name                = "aksidentity"
  resource_group_name = azurerm_resource_group.terraform_infra.name
  location            = azurerm_resource_group.terraform_infra.location
}

module "aks_cluster" {
  depends_on = [module.vnet, azurerm_user_assigned_identity.identity]
  source     = "squareops/aks/azurerm"

  name                              = format("%s-aks", local.name)
  environment                       = local.environment
  kubernetes_version                = local.k8s_version
  create_resource_group             = false                                       # Enable if you want to a create resource group for AKS cluster.
  existing_resource_group_name      = azurerm_resource_group.terraform_infra.name # We will be using resource group create earlier.
  resource_group_location           = azurerm_resource_group.terraform_infra.location
  user_assigned_identity_id         = azurerm_user_assigned_identity.identity.id
  principal_id                      = azurerm_user_assigned_identity.identity.principal_id
  network_plugin                    = local.network_plugin
  net_profile_dns_service_ip        = "192.168.0.10"   # IP address within the Kubernetes service address range that will be used by cluster service discovery. Don't use the first IP address in your address range. The first address in your subnet range is used for the kubernetes.default.svc.cluster.local address.
  net_profile_pod_cidr              = "10.244.0.0/16"  # For aks pods cidr, when choosen "azure" network plugin these value will be passed as null.
  net_profile_docker_bridge_cidr    = "172.17.0.1/16"  # It's required to select a CIDR for the Docker bridge network address because otherwise Docker will pick a subnet automatically, which could conflict with other CIDRs. You must pick an address space that doesn't collide with the rest of the CIDRs on your networks, including the cluster's service CIDR and pod CIDR. Default of 172.17.0.1/16.
  net_profile_service_cidr          = "192.168.0.0/16" # This range shouldn't be used by any network element on or connected to this virtual network. Service address CIDR must be smaller than /12. You can reuse this range across different AKS clusters.
  default_agent_pool_name           = "addons"
  default_agent_pool_count          = "1"
  default_agent_pool_size           = "Standard_DS2_v2"
  host_encryption_enabled           = false
  default_node_labels               = { Addons-Services = "true" }
  os_disk_size_gb                   = 30
  auto_scaling_enabled              = true
  agents_min_count                  = 1
  agents_max_count                  = 2
  node_public_ip_enabled            = false           # If we want to create public nodes set this value "true"
  agents_availability_zones         = ["1", "2", "3"] # Does not applies to all regions please verify the availablity zones for the respective region.
  rbac_enabled                      = true
  oidc_issuer_enabled               = true
  open_service_mesh_enabled         = true # Add on for the open service mesh (istio)
  private_cluster_enabled           = true # AKS Cluster endpoint access, Disable for public access
  sku_tier                          = "Free"
  subnet_id                         = module.vnet.private_subnets
  admin_username                    = "azureuser" # node pool username
  public_ssh_key                    = data.azurerm_key_vault_secret.ssh_key.value
  agents_type                       = "VirtualMachineScaleSets"                                                     # Creates an Agent Pool backed by a Virtual Machine Scale Set.
  net_profile_outbound_type         = "loadBalancer"                                                                # The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer.
  log_analytics_workspace_sku       = "PerGB2018"                                                                   # refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
  log_analytics_solution_enabled    = true                                                                          # Log analytics solutions are typically software solutions with data visualization and insights tools.
  control_plane_logs_scrape_enabled = true                                                                          # Scrapes logs of the aks control plane
  control_plane_monitor_name        = format("%s-%s-aks-control-plane-logs-monitor", local.name, local.environment) # Control plane logs monitoring such as "kube-apiserver", "cloud-controller-manager", "kube-scheduler"
  additional_tags                   = local.additional_tags
}

module "aks_managed_node_pool" {
  depends_on = [module.aks_cluster]
  source     = "squareops/aks/azurerm//modules/managed_node_pools"

  resource_group_name   = azurerm_resource_group.terraform_infra.name
  orchestrator_version  = local.k8s_version
  location              = azurerm_resource_group.terraform_infra.location
  vnet_subnet_id        = module.vnet.private_subnets
  kubernetes_cluster_id = module.aks_cluster.kubernetes_cluster_id
  node_pools = {
    app = {
      vm_size                  = "Standard_DS2_v2"
      auto_scaling_enabled     = true
      os_disk_size_gb          = 50
      os_disk_type             = "Managed"
      node_count               = 1
      min_count                = 1
      max_count                = 2
      availability_zones       = ["1", "2", "3"]
      enable_node_public_ip    = false # if set to true node_public_ip_prefix_id is required
      node_public_ip_prefix_id = ""
      node_labels              = { App-service = "true" }
      node_taints              = ["workload=example:NoSchedule"]
      host_encryption_enabled  = false
      max_pods                 = 30
      agents_tags              = local.additional_tags
    },
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.name}acr"
  resource_group_name = azurerm_resource_group.terraform_infra.name
  location            = azurerm_resource_group.terraform_infra.location
  sku                 = "Standard"
  admin_enabled       = false

  tags = local.additional_tags
}

module "aks_addons" {
  depends_on = [module.vnet, module.aks_cluster, module.aks_managed_node_pool]
  source     = "squareops/aks-addons/azurerm"

  environment                                   = local.environment
  name                                          = local.name
  aks_cluster_name                              = module.aks_cluster.cluster_name
  resource_group_name                           = azurerm_resource_group.terraform_infra.name
  resource_group_location                       = azurerm_resource_group.terraform_infra.location
  single_az_sc_config                           = [{ name = "infra-service-sc", zone = "1" }]
  cert_manager_letsencrypt_email                = "example@kwal.ai"
  single_az_storage_class_enabled               = true
  service_monitor_crd_enabled                   = true
  reloader_enabled                              = true
  ingress_nginx_enabled                         = true
  internal_ingress_nginx_enabled                = false
  cert_manager_enabled                          = true
  cert_manager_install_letsencrypt_http_issuers = true
  external_secrets_enabled                      = true
  keda_enabled                                  = false
  istio_enabled                                 = true
}

module "vnet" {
  depends_on = [azurerm_resource_group.terraform_infra]
  source     = "squareops/vnet/azurerm"

  name                         = local.name
  address_space                = local.address_space
  environment                  = local.environment
  create_public_subnets        = true
  create_private_subnets       = true
  create_database_subnets      = false
  num_public_subnets           = "1"
  num_private_subnets          = "1"
  num_database_subnets         = "0"
  create_resource_group        = false                                       # Enable if you want to a create resource group for AKS cluster.
  existing_resource_group_name = azurerm_resource_group.terraform_infra.name # We will be using resource group create earlier.
  resource_group_location      = local.region
  create_vpn                   = false
  create_nat_gateway           = true
  logging_enabled              = false
  additional_tags              = local.additional_tags
}

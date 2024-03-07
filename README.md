## Terraform AKS Reference

Terraform reference to deploy a production-ready AKS (Azure Kubernetes Service) cluster. This reference takes care of provisioning a secure Azure Virtual Network (VNet), deploy an AKS cluster, and configure it with required resources, controllers, and utilities to start deploying applications.

## Requirements and Prerequisites

1. An Azure account
2. A system with [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [kubectl](https://kubernetes.io/docs/tasks/tools/) installed

This repository contains Terraform configuration files for deploying a set of modules in a specific order. The tfstate module must be deployed first, followed by the main module.

## Deploying the tfstate Module

The tfstate module is used for storing the Terraform state file remotely, which is a recommended practice to ensure consistency and collaboration among team members.

To deploy the tfstate module, navigate to the **tfstate** directory and run the following commands:

1. terraform init
2. terraform plan
3. terraform apply

Once you have provided the required input, Terraform will create the necessary resources for the tfstate module.

## Deploying the AKS Cluster

After the tfstate module has been deployed, you can deploy the AKS cluster setup. Creating an AKS cluster involves several steps, including setting up an Azure Virtual Network (VNet), creating an AKS cluster, and configuring an AKS node pool.

**Setup SSH Keys for AKS nodes**
1. Generate SSH keys using Azure CLI:
```bash
az sshkey create --name "mySSHKey" --resource-group "myResourceGroup"
```
**The resulting output lists the new key files' paths:**
```bash
Private key is saved to "/home/user/.ssh/7777777777_9999999".
Public key is saved to "/home/user/.ssh/7777777777_9999999.pub".
```
2. Create Azure Key Vault using Azure CLI:
```bash
az keyvault create --name MyKeyVault --resource-group MyResourceGroup --location "East US"
```
3. Set SSH public key in Key Vault using Azure CLI:
```bash
az keyvault secret set --vault-name "MyKeyVault" --name "mySSHKey" --file /home/user/.ssh/7777777777_9999999.pub
```
4. Update the Key Vault name and ID in the Terraform data variables:
Update the `aks.tf` file with the following values for key vault:
```bash
data "azurerm_key_vault_secret" "ssh_key" {
  name         = "mySSHKey"
  key_vault_id = "/subscriptions/{subscription-id}/resourceGroups/MyResourceGroup/providers/Microsoft.KeyVault/vaults/MyKeyVault"
}
```

**Initialize Terraform:** Open a terminal or command prompt and navigate to your project directory. Run the command `terraform init` to initialize Terraform in the project directory. This command downloads the necessary provider plugins and sets up the backend configuration.

**Plan the Changes:** Execute `terraform plan` to generate an execution plan. Terraform analyzes your code and infrastructure state to determine the actions it will take. Review the plan output to understand the changes that will occur when applying the Terraform configuration.

**Apply the Changes:** Run `terraform apply` to apply the changes defined in your Terraform code. Terraform will create, modify, or destroy resources as necessary to achieve the desired state. Confirm the changes by typing `yes` when prompted.

### VNet

The [squareops/vnet/azurerm](https://github.com/squareops/terraform-azurerm-vnet/tree/main) module available on the Terraform Registry is designed to create and manage Azure Virtual Network (VNet) resources in Microsoft Azure.

The module can be used to create a new VNet along with its associated resources such as subnets, route tables, security groups, and network security groups (NSG). It offers a simplified and standardized way to create VNet infrastructure, while also providing flexibility to customize VNet resources based on specific requirements.

The [squareops/vnet/azurerm](https://github.com/squareops/terraform-azurerm-vnet/tree/main) module offers a range of configuration options, including the ability to specify CIDR blocks for the VNet and subnet ranges, assign names and tags to VNet resources, enable DNS support, and configure network security groups. Additionally, the module provides pre-configured modules for creating subnets in different availability zones (AZs) and associating NSGs.

By using this module, Azure users can save time and effort in setting up VNet infrastructure and ensure that their VNets are created in a consistent and reproducible manner. The module is provided by Microsoft Azure and is actively maintained.

### AKS

The [squareops/aks/azurerm](https://github.com/squareops/terraform-azurerm-aks/tree/main) module available on the Terraform Registry is designed to create and manage an AKS (Azure Kubernetes Service) cluster in Microsoft Azure.

The module provides a simplified and standardized way to create and manage the Kubernetes control plane and worker nodes in AKS. It automates the process of creating the necessary AKS resources such as resource groups, virtual networks, security groups, and the AKS cluster itself.

The [squareops/aks/azurerm](https://github.com/squareops/terraform-azurerm-aks/tree/main) module offers a range of configuration options, such as the ability to specify the number of worker nodes, VM sizes, and Kubernetes version. It also provides pre-configured modules for configuring node pools with different VM sizes, enabling monitoring and logging, and integrating with Azure Container Registry.

By using this module, Azure users can set up a Kubernetes cluster on AKS in a simple, efficient, and reproducible manner. It also ensures that the AKS cluster is created with best practices in mind and that it is secured according to industry standards. The module is provided by Microsoft Azure and is actively maintained.

### AKS Add-ons

The [squareops/aks-addons/azurerm](https://github.com/squareops/terraform-azurerm-aks-addons/tree/main) module available on the Terraform Registry is designed to configure additional subnets for AKS add-ons in Microsoft Azure.

The module provides a simplified and standardized way to create and manage subnets for AKS add-ons such as Azure CNI (Container Networking Interface), Azure Firewall, and Azure Application Gateway. It automates the process of creating the necessary subnets and associating them with the AKS cluster.

By using this module, Azure users can configure AKS add-ons in a consistent and reproducible manner. It ensures that the subnets are created with the appropriate configurations and that they are integrated seamlessly with the AKS cluster. The module is provided by Microsoft Azure and is actively maintained.

# terraform-aks-example

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vnet"></a> [vnet](#module\_vnet) | squareops/vnet/azurerm | n/a |
| <a name="module_aks_cluster"></a> [aks\_cluster](#module\_aks\_cluster) | squareops/aks/azurerm | n/a |
| <a name="module_aks_managed_node_pool"></a> [aks\_managed\_node\_pool](#module\_aks\_managed\_node\_pool) | squareops/aks/azurerm//modules/managed_node_pools | n/a |
| <a name="module_aks_addons"></a> [aks\_addons](#module\_aks\_addons) | squareops/aks-addons/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.terraform_infra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_key_vault_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The common name of the resource |
| <a name="output_environment"></a> [environment](#output\_environment) | The name of the environment |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Kubernetes cluster |
| <a name="output_default_ng_rg_name"></a> [default\_ng\_rg\_name](#output\_default\_ng\_rg\_name) | The name of the resource group for the default node group |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The location of the resource group |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the virtual network |
| <a name="output_vnet_subnets_name_id"></a> [vnet\_subnets\_name\_id](#output\_vnet\_subnets\_name\_id) | A map that can be queried to get subnet IDs by subnet names |
| <a name="output_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#output\_user\_assigned\_identity\_id) | The ID of the user-assigned identity for CNI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

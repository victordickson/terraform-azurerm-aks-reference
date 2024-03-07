# Define your outputs here
output "name" {
  description = "The common name of the resource"
  value       = local.name
}

output "environment" {
  description = "The name of the environment"
  value       = local.environment
}

output "cluster_name" {
  description = "The name of the Kubernetes cluster"
  value       = module.aks_cluster.cluster_name
}

output "default_ng_rg_name" {
  description = "The name of the resource group for the default node group"
  value       = module.aks_cluster.default_ng_rg_name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.terraform_infra.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.terraform_infra.location
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.vnet.vnet_name
}

output "vnet_subnets_name_id" {
  description = "A map that can be queried to get subnet IDs by subnet names"
  value       = module.vnet.vnet_subnets_name_id
}

output "user_assigned_identity_id" {
  description = "The ID of the user-assigned identity for CNI"
  value       = azurerm_user_assigned_identity.identity.id
}

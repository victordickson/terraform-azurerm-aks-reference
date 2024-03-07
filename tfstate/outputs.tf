output "terraform_state_resource_group_name" {
  value       = module.backend.terraform_state_resource_group_name
  description = "The name of the resource group where Terraform state is stored"
}

output "terraform_state_storage_account" {
  value       = module.backend.terraform_state_storage_account
  description = "The name of the storage account where Terraform state is stored"
}

output "terraform_state_storage_container_name" {
  value       = module.backend.terraform_state_storage_container_name
  description = "The name of the storage container where Terraform state is stored"
}

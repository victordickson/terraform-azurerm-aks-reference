locals {
  region      = "West US"
  environment = "prod"
  name        = "kwal"
  additional_tags = {
    Owner      = "dickson@kwal.ai"
    Expires    = "Never"
    Department = "DevOps"
  }
}

module "backend" {
  source                  = "squareops/tfstate-asc/azurerm"
  resource_group_name     = local.name
  storage_account_name    = local.name
  storage_container_name  = "tfstate" # unique storage container name
  resource_group_location = local.region
  environment             = local.environment
}

terraform {
  backend "azurerm" {
    resource_group_name  = "prod-kwal-tfstate-rg" # "prod-skaf-tfstate-rg"
    storage_account_name = "kwalprod" # "skafprod"
    container_name       = "tfstate-prod-container" # "tfstate-prod-container"
    key                  = "terraform-infra/aks-reference.tfstate" # "terraform-infra/aks-reference.tfstate"
  }
}

locals {
  region      = "East US 2"
  environment = "prod"
  name        = "kwal"
  additional_tags = {
    Owner      = "dickson@kwal.ai"
    Expires    = "Never"
    Team       = "DevOps"
  }
  address_space  = "10.20.0.0/16"
  network_plugin = "azure"  # You can choose "kubenet(basic)" or "azure(advanced)" refer https://learn.microsoft.com/en-us/azure/aks/concepts-network#kubenet-basic-networking
  k8s_version    = "1.29" # Kubernetes cluster version
}

# Terraform provider

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Kubernetes provider

provider "kubernetes" {
  host                   = module.aks_cluster.host
  client_certificate     = module.aks_cluster.client_certificate
  client_key             = module.aks_cluster.client_key
  cluster_ca_certificate = module.aks_cluster.cluster_ca_certificate
  config_path            = "~/.kube/config"
}

# Helm provider

provider "helm" {
  kubernetes {
    host                   = module.aks_cluster.host
    client_certificate     = module.aks_cluster.client_certificate
    client_key             = module.aks_cluster.client_key
    cluster_ca_certificate = module.aks_cluster.cluster_ca_certificate
    config_path            = "~/.kube/config"
  }
}

resource "azurerm_resource_group" "terraform_infra" {
  name     = format("%s-%s-rg", local.environment, local.name)
  location = local.region
  tags     = local.additional_tags
}

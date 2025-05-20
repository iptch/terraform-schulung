terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "core"

  storage_use_azuread = true
  environment         = "public"

  features {
  }
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix  = ["workshop"]
}

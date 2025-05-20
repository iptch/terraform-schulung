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

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = "West Europe"
}

resource "azurerm_storage_account" "this" {
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Authenticate via Entra ID
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true

  # Use Infrastructure encryption
  infrastructure_encryption_enabled = true
}

resource "azurerm_storage_container" "this" {
  name                  = module.naming.storage_container.name_unique
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

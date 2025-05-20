terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29"
    }
  }
  # backend "azurerm" {
  #   use_azuread_auth     = true
  #   resource_group_name  = "rg-workshop-????"
  #   storage_account_name = "stworkshop????"
  #   container_name       = "stct-workshop-???"
  #   key                  = "terraform.tfstate"
  # }
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
  suffix  = var.suffix
  prefix  = var.prefix
}

resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = var.location
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

data "azurerm_client_config" "this" {
}

resource "azurerm_role_assignment" "reader_and_data_access" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Reader and Data Access"
  principal_id         = data.azurerm_client_config.this.object_id
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_container.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.this.object_id
}

variable "suffix" {
  description = "Suffix for the naming module"
  type        = list(string)
  default     = ["workshop"]
}

variable "prefix" {
  description = "Prefix for the naming module"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "Location for the naming module"
  type        = string
  default     = "westeurope"
}

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "container_name" {
  value = azurerm_storage_container.this.name
}

output "backend_azruerm" {
  value = {
    tenant_id            = data.azurerm_client_config.this.tenant_id
    subscription_id      = data.azurerm_client_config.this.subscription_id
    use_azuread_auth     = true
    resource_group_name  = azurerm_resource_group.this.name
    storage_account_name = azurerm_storage_account.this.name
    container_name       = azurerm_storage_container.this.name
    key                  = "terraform.tfstate"
  }
}

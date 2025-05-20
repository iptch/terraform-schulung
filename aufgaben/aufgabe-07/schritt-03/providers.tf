provider "azurerm" {
  resource_provider_registrations = "core"

  storage_use_azuread = true
  environment         = "public"

  features {
  }
}

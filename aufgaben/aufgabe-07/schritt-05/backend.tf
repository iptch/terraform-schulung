terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "rg-workshop-k3ds"
    storage_account_name = "stworkshopk3ds"
    container_name       = "stct-workshop-k3ds"
    key                  = "terraform.tfstate"
  }
}

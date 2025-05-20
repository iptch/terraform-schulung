module "storage_account" {
  source = "../schritt-01/modules/storage_account"

  prefix   = []
  suffix   = ["workshop"]
  location = "westeurope"
}

moved {
  from = azurerm_resource_group.this
  to   = module.storage_account.azurerm_resource_group.this
}

moved {
  from = azurerm_role_assignment.reader_and_data_access
  to   = module.storage_account.azurerm_role_assignment.reader_and_data_access
}

moved {
  from = azurerm_role_assignment.storage_blob_data_contributor
  to   = module.storage_account.azurerm_role_assignment.storage_blob_data_contributor
}

moved {
  from = azurerm_storage_account.this
  to   = module.storage_account.azurerm_storage_account.this
}

moved {
  from = azurerm_storage_container.this
  to   = module.storage_account.azurerm_storage_container.this
}

moved {
  from = module.naming.random_string.first_letter
  to   = module.storage_account.module.naming.random_string.first_letter
}

moved {
  from = module.naming.random_string.main
  to   = module.storage_account.module.naming.random_string.main
}

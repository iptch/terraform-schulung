# Terraform Schulung - Aufgabe 03

Terraform State auslesen:

```
# resource_group_name
terraform state show azurerm_resource_group.this
# storage_account_name
terraform state show azurerm_storage_account.this
# container_name
terraform state show azurerm_storage_container.this.name
```

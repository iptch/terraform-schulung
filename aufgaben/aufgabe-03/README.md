# Terraform Schulung - Aufgabe 03

Für diese Aufgabe bitte das gleiche Verzeichnis verwenden, wie für Aufgabe 02.

Für die Schritte 01 und 02 gibt es eine mögliche Lösung im Verzeichnis `schritt-xx`.

## Schrittt 1 - Daten für Backend azurerm auslesen

Um das Backend `azurerm` verwenden zu können, benötigen wir ein paar Daten.
Einige Werte werden analog vom Provider `azurerm` bereits benötigt und können verwendet werden.

- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`

```bash
terraform state list
# resource_group_name
terraform state show ???
# storage_account_name
terraform state show ???
# container_name
terraform state show ???
```

## Schritt 02 - Terraform backend erfassen

Mit den nun ermittelten Daten, können wir das Backend anpassen:

```terraform
terraform {
  ...
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "rg-workshop-????"
    storage_account_name = "stworkshop????"
    container_name       = "stct-workshop-????"
    key                  = "terraform.tfstate"
  }
  ...
}
```

## Schritt 03 - Terraform state migrieren

Nun ist es an der Zeit den State zu migrieren:

```bash
terraform init -migrate-state
```

Wenn alles in Ordnung ist, muss die Migration noch bestätigt werden.

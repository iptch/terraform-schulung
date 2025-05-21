# Terraform Schulung - Aufgabe 10

⚠️ Diese Aufgabe im in Aufgabe 9 erstellten Repository umsetzen ⚠️

In dieser Aufgabe bauen wir auf gestern auf: Wir definieren ein kleines Terraform-Projekt mit einem *Remote State File*. Das Terraform-Projekt führen wir aber nicht via `terraform plan -out tfplan` und `terraform apply tfplan` aus, sondern erweitern in Aufgabe 11 die Pipeline.

Folgende Ziele sind in dieser Aufgabe zu erreichen.

1. Erstellung eines Feature-Branch
2. Erstellung eines kleinen Terraform-Projekts
3. Konfiguration des Remote State Files

## Schritt 01 - Feature-Branch erstellen

Bevor ein Feature-Branch erstellt wird, versichern wir uns, dass wir uns auf dem Main-Branch befinden `git status` und keine offenen Änderungen in *remote* Main-Branch existieren `git pull origin`.

```
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

```
Already up to date.
```

Der Befehl für die Branch-Erstellung lautet `git checkout -b feature/resource-and-pipeline-configuration`.

## Schritt 02 - Terraform-Projekt erstellen

Das kleine Terraform-Projekt benötigt nicht viel, da dies nicht wie gestern die Grundlage für den *Remote State* ist. Definiert in Terraform folgende Blöcke aus:

```terraform
terraform {
    (...)
}
```

<details>
<summary>Lösungshinweis</summary>

Die *????* mit dem generierten Postfix ersetzen.

```terraform
terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29"
    }
  }
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "rg-workshop-????"
    storage_account_name = "stworkshop????"
    container_name       = "stct-workshop-???"
    key                  = "terraform.tfstate"
  }
}
```
</details>
<br>

```terraform
provider "azurerm" {
  (...)
}
```

<details>
<summary>Lösungshinweis</summary>

```terraform
provider "azurerm" {
  resource_provider_registrations = "core"

  storage_use_azuread = true
  environment         = "public"

  features {
  }
}
```
</details>
<br>

```terraform
module "naming" {
  (...)
}
```

<details>
<summary>Lösungshinweis</summary>

```terraform
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix  = ["workshop"]
}
```
</details>
<br>

```terraform
resource "azurerm_resource_group" "this" {
  (...)
}
```

<details>
<summary>Lösungshinweis</summary>

```terraform
resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = "West Europe"
}
```
</details>
<br>

```terraform
resource "azurerm_storage_account" "this" {
  (...)
}
```

<details>
<summary>Lösungshinweis</summary>

Hier könnt ihr auch auf euer Modul aus Aufgabe 7 und 8 zurückgreifen.

```terraform
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
```
</details>
<br>

Zusätzlich möchten wir den Namen der *Resource Group* ausgeben. Auf die *Storage Container* und *Role Assignments* verzichten wir in diesem kleinen Projekt.

```terraform
output "resource_group_name" {
  (...)
}
```

<details>
<summary>Lösungshinweis</summary>

```terraform
output "resource_group_name" {
  value = azurerm_resource_group.this.name
}
```
</details>
<br>

## Schritt 03 - Verifizierung

Das Deployment wird via Pipeline gemacht. Aber mittels `terraform plan` verifizieren wir, dass syntaktisch alles korrekt ist.

## Schritt 04 - Änderungen committen

Durch die Konfiguration des Terraform-Projekts wurde ein Teil des Feature-Branch-Scope erledigt. Das ist der richtige Zeitpunkt, um diese Änderungen zu committen.

Wie in der vorhergehenden Aufgabe wird mit `git add .` die Dateien Git hinzugefügt. Mit `git commit -m "Added Terraform project"` werden die Änderungen committed. Auf `git push origin` verzichten wir noch.
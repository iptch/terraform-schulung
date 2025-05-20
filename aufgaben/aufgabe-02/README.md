# Terraform Schulung - Aufgabe 02

Terraform mit Azure verbinden.

Die folgneden Schritte und Aufgaben bauen aufeinander auf (ausser Aufgabe 04).
Für diese Aufgaben bitte immer das gleiche Verzeichnis verwenden.

Für jeden Schritt gibt es eine mögliche Lösung im Verzeichnis `schritt-xx`.

## Schritt 01 - Provider azurerm

Als erstes ergänzen wir den Terraform Block, um die Informationen zum Provider `azurerm`:

```terraform
terraform {
...
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
...
}
```

Wir akzeptieren jede Version `4.y.z` mit dem Versions Constraint `~> 4.0`. Diese Flexibilität ist hilfreich beim Einsatz von Module.
Als nächsten fügen wir die Konfiguration für den Provider hinzu.

```terraform
provider "azurerm" {
  features {
    resource_provider_registrations = ["core"]
  }
}
```

Da fehlen noch einige Werte. Diese wollen wir über Umgebungsvariablen setzen.

```bash
export ARM_ENVIRONMENT="public"
export ARM_STORAGE_USE_AZUREAD="true"

export ARM_TENANT_ID="tbd"
export ARM_SUBSCRIPTION_ID="tbd"
```

Je nach Art des Login bitte weitere Parameter ergänzen.

**Warum aber überhaupt Umgebungsvariablen einsetzen?**
Die Verwendung von Umgebungsvariablen erhöht die Flexibilität.
Z.B. kann für die (lokale) Entwicklung der eigene Account eingesetzt werden, also [Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli), während für die Pipeline [Authenticating using a Service Principal with Open ID Connect](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_oidc) zum Einsatz kommen kann. Dabei bleibt der Terraform Code der gleiche.

Um die Benennung von Ressourcen zu vereinfachen setzen wir auf das Module `naming` ein.

```terraform
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
  suffix = [ "workshop" ]
}
```

Nun wollen wir das ganze ausführen. Dafür verwenden wir die folgenden Kommandos:

- `terraform init` um Terraform zu initialisieren. Dabei werden die benötigten Provider und Module heruntergeladen.
- `terraform plan -out tfplan` um einen Plan zu erstellen, der im Apply durchgeführt wird.
- `terraform apply tfplan` um den zuvor erstellten Plan auszuführen. Ohne `tfplan` würde `terraform apply` selbst einen Plan erstellen, der anschliessend bestätigt werden müsste.

- `terraform destroy` brauchen wir erst später, um unsere ganze Konfiguration wieder zu löschen.

Im folgenden legen wir folgende Ressourcen an:

- Resource Group
- Storage Account
- Container im Storage Account

Weitere Informationen:

- [Provider `azurerm`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Module `naming`](https://registry.terraform.io/modules/Azure/naming/azurerm/latest)
- [Terraform CLI Overview](https://developer.hashicorp.com/terraform/cli/commands)

## Schritt 02 - Resource Group

Nun legen wir eine Resource Group an. Dabei verwenden wir als Namen den Wert von `module.naming.resource_group.name_unique`.
Wir verwenden als Beispiel die Region `West Europe` für die Resource Group:

```terraform
resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = "West Europe"
}
```

Weitere Informationen:

- [Resource `azurerm_resource_group`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

## Schritt 03 - Storage Account

In diese Resource Group kommt der Storage Account. Als Namen verwenden wir den Wert von `module.naming.storage_account.name_unique`.

```terraform
resource "azurerm_storage_account" "this" {
  name                      = module.naming.storage_account.name_unique
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"

  # Authorize via Entra ID
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true

  # Use Infrastructure encryption
  infrastructure_encryption_enabled  = true
}
```

Weitere Informationen:

- [Resource `azurerm_storage_account`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

## Schritt 04 - Container

Zu letzt wollen wir einen Container im Storage Account bereitstellen. Für den Namen verwenden wir wieder den entsprechenden Wert aus dem Module `naming`.

```terraform
resource "azurerm_storage_container" "this" {
  name                  = module.naming.storage_container.name_unique
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
```

Weitere Informationen:

- [Resource `azurerm_storage_container`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

## Schritt 05 - Berechtigung

Damit wir den Container später verwenden können, müssen wir noch Berechtigungen erteilen:

- [Reader and Data Access](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/storage#reader-and-data-access)
- [Storage Blob Data Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/storage#storage-blob-data-contributor) um im Container lesen und schreiben zu können. (Das ginge auch auf dem Storage Account, aber wegen least-privilege gewähren wir es nur auf dem Container.)

Das machen wir jetzt, da es bis zu 10 Minuten dauern kann bis diese Berechtigungen tatsächlich in Kraft tretten (siehe [Zuweisen einer Azure-Rolle für den Zugriff auf Blobdaten](https://learn.microsoft.com/de-de/azure/storage/blobs/assign-azure-role-data-access?tabs=portal)).

Zunächst benötigen wir die ObjectID der Identität, die gerade für Terraform verwendet wird.

```terraform
data "azurerm_client_config" "this" {
}
```

Anschliessend wird der Identität (ObjectID) die oben gelisteten Rollen (Reader and Data Access und Storage Blob Data Contributor) auf den Container (Scope) zugewiesen.

Weitere Information:

- [Data `azurerm_client_config`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)
- [Resource `azurerm_role_assignment`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)


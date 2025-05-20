# Terraform Schulung - Aufgabe 08

Wir bauen auf dem Ergebnis von Aufgabe 07 auf, vor allem auf dem Terraform Module davon.
Wir behalten den Aufbau bei, damit wir besser testen können.

## Schritt 01 - Ressource Group optional

Wir wollen die Möglichkeit haben, dass unser Storage Account auch in einer bestehenden Ressource Group angelegt wird statt in einer eigenen.

- Wir brauchen eine Variable, z.B. `enable_resource_group_creation`, die kennzeichnet, ob wir eine Ressource Group anlegen oder eine bestehende verwenden sollen.
- Wir dürfen eine Ressource Group nur anlegen, wenn `enable_resource_group_creation` den Wert `true` hat.
- Da die (Terraform) Ressource für die Azure Resource Group nun ev. nicht exisitert, müssen wir die Referenzen darauf entfernen. Gleichzeit müssen wir sicherstellen, dass die Azure Resource Group immer vor dem Storage Account angelgt

Weitere Informationen:

- [Eingabe Variablen](https://developer.hashicorp.com/terraform/language/values/variables)
- [`count`](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [`depends_on`](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
- [Funktionen](https://developer.hashicorp.com/terraform/language/functions)

## Schritt 02 - Role assignments übergeben

Die Role Assignments werden aktuell für das Objekt vorgenommen, dass die Terraform Verbindung zu Azure herstellt, also eine Service Principal oder User Objekt. Wir wollen die Rollen allerdings Gruppen zuweisen. Daher wollen wir zukünftig die Rollenzuweisungen über eine Variable mitgeben. Nach Möglichkeit soll die gleiche Variable für den Storage Account selbst, aber auch für den Container verwendet werden.

Weitere Informationen:

- [`for_each`](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

## Schritt 03 - Container optional

Die Container sollen nur noch optional angelegt werden. Das muss in den Outputs entsprechend berücksichtigt werden.

## Schritt 04 - Inspiration von Azure Verified Module holen

Lasst Euch vom Azure Verified Module für Storage Account Ressourcen inspierieren:

- Terraform Registry: [avm-res-storage-storageaccount](https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest)
- GitHub: [terraform-azurerm-avm-res-storage-storageaccount](https://github.com/Azure/terraform-azurerm-avm-res-storage-storageaccount)

Was machen sie anders?

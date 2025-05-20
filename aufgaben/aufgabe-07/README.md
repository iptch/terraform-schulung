# Terraform Schulung - Aufgabe 07

Ergebnis von Aufgaben 2, 3, 5 und 6 werden umgebaut.

Bei Bedarf kann auf der Musterlösung von Aufgabe 6 Schritt 1 aufgebaut werden.

## Schritt 01 - Module `storage_account` aufbauen

Wir wollen die Generierung des Storage Account als Terraform Module

Lege ein Verzeichnis `modules` an und darin ein Verzeichnis `storage_account`.

1. **Verschiebe** die folgenden Dateien in das Verzeichnis `modules/storage_account`:

- `outputs.tf` für die Outputs
- `variables.tf` für die Konfiguration der Variablen
- `main.tf` für den Rest

2. **Kopiere** die Datei `versions.tf` in das Verzeichnis `modules/storage_account`.

3. **Erstelle** die Datein `main.tf`im aktuellen Verzeichnis (also nicht `modules/storage_account`).

Die Verzeichnis-Struktur müsste nun wie folgt aussehen:

```bash
packages/button
├── modules
│   └── storage_account
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── variables.tf
├── backend.tf
├── main.tf
├── providers.tf
└── version.tf
```

4. **ACHTUNG** Führe `terraform plan` aus. **ACHTUNG**

Wenn Dein State bereits Resourcen enthält, würden diese nun gelöscht werden.
Schliesslich ist unser `main.tf`aktuell leer.

Das wollen wir aber gar nicht!

## Schritt 02 - Module `storage_account` aufrufen

In der Datein `main.tf`im aktuellen Verzeichnis fügen wir folgenden Code ein:

```terraform
module "storage_account" {
  source = "./modules/storage_account"

}
```

Wir haben ein neues Module hinzugefügt, deswegen müssen wir nun folgendes Kommando ausführen:
`terraform init`.

**ACHTUNG** Anschliessend führen wir `terraform plan` aus. **ACHTUNG**

**Warum gibt es keinen Fehler?**
Das Module hat zwar Variablen definiert, aber die haben alle einen Default Wert. Daher gibt es keinen Fehler.

Im Plan steht, dass die bestehenden Ressourcen gelöscht und neue angelegt werden.

## Schritt 03 - Default-Werte anpassen

Entferne in der Datei `modules/storage_account/variables.tf` die Default Werte.

Was liefert ein `terraform plan` jetzt?

Es gibt 3-mal den Fehler **Missing required argument**.

Füge in der Datei `main.tf` die entsprechenden Argumente hinzu.

Was liefert ein `terraform plan` jetzt?

Es werden immer noch die bestehenden Sachen gelöscht und neue angelegt.
Müssen wir wirklich alles löschen und neu anlegen? Nein!

## Schritt 04 - Moved

Wir können die bestehenden Ressourcen behalten. Dafür müssen wir nur Terraform mitteilen, dass sie die alten Ressourcen verwenden soll. D.h. wir müssen den State anpassen.

Dafür gibt es zwei Möglichkeiten:

- Zum einen könnten wir mit der Terraform CLI arbeiten, siehe [`terraform state mv`](https://developer.hashicorp.com/terraform/cli/commands/state/mv).
- Zum anderen könnten wir den [Block `moved`](https://developer.hashicorp.com/terraform/language/moved) einsetzen.

Wir verwenden den Block `moved`. Dafür erfassen wir in `main.tf` einen Eintrag nach dem folgenden Muster:

```terraform
moved {
  from = ...
  to   = ...
}
```

Die Daten für `from` und `to` können wir aus dem vorherigen Plan auslesen:

- Unter `from` kommt jeweils eine Ressource, die gelöscht werden würde.
- Unter `to` kommt die entsprechende Ressource, die neu angelegt werden würde.

Was liefert ein `terraform plan` jetzt?

Nun sollten keine Ressourcen mehr gelöscht oder neu angelegt werden. Statt dessen sollten alle als `moved` aufgeführt werden.

## Schritt 05 - Output übernehmen

Wir wollen den Output oder zumindest, den für das Backend relvanten Teil übernehmen.

Lege dazu eine Datei `outputs.tf` mit folgendem Inhalt an:

```terraform
output "backend_azruerm" {
  value = module.storage_account.backend_azruerm
}
```

Damit übernehmen wir den Output `backend_azruerm` aus dem Module `storage_account` und geben ihn wieder als `backend_azruerm` aus.

Nun sind wir bereit für folgende Kommando-Abfolge:

```bash
terraform plan -out tfplan
```

Den Plan überprüfen. Falls in Ordnung, geht es weiter mit:

```bash
terraform apply tfplan
```

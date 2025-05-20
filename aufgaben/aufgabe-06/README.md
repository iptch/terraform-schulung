# Terraform Schulung - Aufgabe 06

Ergebnis von Aufgaben 2, 3 & 5 erweitern.

Bei Bedarf kann mit der Datei `main.tf` in diesem Verzeichnis gestartet werden.
Es wird dabei noch das Backend `local` für den Terraform State verwendet.
Die Daten für die Konfiguration für Backend `azurerm` ist vorbereitet.

## Schrittt 01 - Datei `main.tf` aufteilen

Die Datei `main.tf` in folgende Dateien aufteilen:

- `backend.tf` für die Backend Konfiguration
- `outputs.tf` für die Outputs
- `providers.tf` für die Konfiguration der Providers
- `variables.tf` für die Konfiguration der Variablen
- `versions.tf` für die Konifguration der Versionen
- `main.tf` für den Rest

Anschliessend mit `terraform plan` überprüfen, dass sich nichts geändert hat.

## Schrittt 02 - Documentation

Wenn möglich mit `terraform-docs` (Webiste)[https://terraform-docs.io/] automatisiert, sonst manuel analog zu [Azruerm Naming Module](https://github.com/Azure/terraform-azurerm-naming/blob/master/README.md).

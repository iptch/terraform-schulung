# Terraform Schlung - Aufgabe 05

Ergebnis von Aufgaben 2 und 3 erweitern.

Bei Bedarf kann mit der Datei `main.tf` in diesem Verzeichnis gestartet werden.
Es wird dabei noch das Backend `local` für den Terraform State verwendet.
Die Daten für die Konfiguration für Backend `azurerm` ist vorbereitet.

Für jeden Schritt gibt es eine mögliche Lösung im Verzeichnis `schritt-xx`.
Für den Terraform State gilt für die Lösungen das gleiche: Backend `local` konfiguriert, Backend `azurerm` vorbereitet.

## Schritt 01 - Eingabe Variablen hinzufügen

Folgende Werte wollen wir als Eingabe-Variablen verwenden:

- `naming`: `suffix` und `prefix`
- `location`

## Schritt 02 - Ausgabe für Backend hinzufügen

Folgende Werte wollen wir ausgeben, damit wir beim nächsten Mal nicht mehr den Terraform State abfragen müssen:

- `resource_group_name`
- `storage_account_name`
- `container_name`

Optional: Die drei Werte direkt zu einem zusammenfassen und um weiter relevante und verfügbar Werte ergänzen.

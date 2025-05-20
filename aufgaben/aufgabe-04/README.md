# Terraform Schulung - Aufgabe 04

Die ganze Aufgabe 04 bitte in einem anderen Ordner ausführen als Aufgabe 02.

Für jeden Schritt gibt es eine mögliche Lösung im Verzeichnis `schritt-xx`.

## Schritt 01 - Ausgabe Variablen

Den Anfang macht "Hallo Welt!".

Bitte eine Datei `main.tf` mit folgenden Terraform Code anlegen:

```terraform
output "hello_world" {
  value = "Hallo Welt!"
}
```

Um Konfiguration auszuführen braucht es:

- Initial ein `terraform init`, um Terraform zu initialisieren
- Anschliessend ein `terraform plan`, um zu planen, was gemacht wird
- Zum Schluss ein `terraform apply`, um den Konfiguration tatsächlich so umzusetzen, inklusive einer Bestätigung

`output` macht eine Information sichtbar, auf der Kommandozeile oder im Parent Module.

Weitere Informationen:

- [Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)
- [terraform init](https://developer.hashicorp.com/terraform/cli/commands/init)
- [terraform plan](https://developer.hashicorp.com/terraform/cli/commands/plan)
- [terraform apply](https://developer.hashicorp.com/terraform/cli/commands/apply)

## Schritt 02 - Lokale Variablen

Als nächstes wollen wir den Inhalt von `hello_world` über eine lokale Variable ausgeben.
Die lokale Variable definieren wir wie folgt:

```terraform
locals {
    hello_world = "Hallo neue Welt!"
}
```

Wie verwenden wir diese locale Variable nun in der Ausgabe?

```terraform
output "hello_world" {
  value = local.hello_world
}
```

**Achtung:** Die Reihenfolge spielt keine Rolle! Terraform führt einen Graph der Abhängigkeiten (dependency graph) und erkennt daher was zuerst gemacht werden muss. D.h. eine zyklische Konfiguration funktioniert nicht!

Vorher haben wir einen Plan für Terraform mit `terraform plan` ermittelt. Diesen haben wir allerdings nicht an `terraform apply` übergeben. Statt dessen hat `terraform apply` einen eigenen Plan erstellt und wir haben diesen anschliessend bestätigt. Im folgenden speichern wir den Plan und übergeben diesen anschliessend an `terraform apply`

```
terraform plan -out tfplan
```

Nun haben wir eine Datei für den Terraform Plan. Diese können wir weiter anschauen.

```
terraform show tfplan
```

Nachdem wir den Plan geprüft haben, können wir diesen ausführen.

```
terraform apply tfplan
```

Eine Alternative für mutige Personen (oder bei kleinen Änderungen):

```
terraform apply -auto-approve
```

Hier wird der vom `apply` erstellten Plan automatisch bestätigt.

Weitere Informationen:

- [terraform show](https://developer.hashicorp.com/terraform/cli/commands/show)

## Schritt 03 - Eingabe Variablen

Als nächsten wollen wir der Terraform Konfiguration dynamische Werte mitgeben. Dafür benötigen wir eine (Eingabe) Variable, z. B.:

```terraform
variable "greeting" {
  description = "Greeting message"
  type        = string
  default     = "Hallo"
}
```

Diesen Wert geben wir an die lokale Variable weiter:

```terraform
locals {
  hello_world = "${var.greeting} Welt!"
}
```

Hierbei nutzen wir die **String Interpolation**, siehe \*weitere Informationen.

Anschliessend sind wir mutig und führen das ganze mit `terraform apply -auto-approve` aus.

Was passiert, wenn wir bei der Variablen die Zeile mit `default = "Hallo"` entfernen und es erneut ausführen?

Da die Variable `greeting` nun keinen Default-Wert hat, müssen wir einen Wert angeben. Dafür gibt es mehrere Möglichkeiten:

- Per Eingabe in der Kommandozeile, was für einfache Werte geht (Strings und Zahlen), aber nicht bei komplexe Variablen (Objekten, Liste)
- Per Kommandozeile z.B. `terraform apply -auto-approve -var 'greeting=Hallo du schöne neu'`, was auch nur für einfache Werte geeignet ist
- Per Konfigurations- / Variablen-Datei, z. B. `terraform apply -auto-approve -var-file="greeting.tfvars"` --> Schritt 04

Weitere Informationen:

- [String Interpolation](https://developer.hashicorp.com/terraform/language/expressions/strings#string-templates)

### Schritt 04 - Konfigurations- / Variablen-Datei

- Konfigurations- / Variablen-Datien haben die Endung `.tfvars` oder `.tfvars.json`.
- Eine Datei `terraform.tfvars` bzw. `terraform.tfvars.json` wird automatisch eingelesen, d.h. auf `-var-file=...` kann verzichtet werden.
- Das gleiche gilt für Dateien, die auf `.auto.tfvars` bzw. `.auto.tfvars.json` enden

Probiere es aus. Starte mit `greeting.tfvars` und folgendem Inhalt:

```
greeting = "Hallo du schöne neue"
```

- `terraform apply -auto-approve -var-file="greeting.tfvars"`
- `greeting.tfvars` umbenennen nach `greeting.auto.tfvars` und anschliessend `terraform apply -auto-approve`
- `greeting.auto.tfvars` umbenennen nach `terraform.tfvars` und anschliessend `terraform apply -auto-approve`

Analog mit `greeting.tfvars,json` und folgendem Inhalt:

```
{
  "greeting": "Hallo du schöne neue"
}
```

**Achtung:** Sollte eine Variable mehrfach gesetzt sein, ist die folgende Reihenfolge zu beachten:

1. Konkrete Konfigurations-/Variablen-Dateien haben Vorrang gegenüber `*.auto.tfvars` und `terraoform.tfvars` bzw. `*.auto.tfvars.json` und `terraoform.tfvars.json`, d.h. die Wert aus der Datei `-var-file="greeting.tfvars"` werden verwendet.
2. Spezifische `*.auto.tfvars` bzw. `*.auto.tfvars.json`-Konfigurations-/Variablen-Dateien haben Vorrang `terraform.tfvars`bzw. `terraform.tfvars.json`.
3. `*.tfvars.json` scheint Vorrang gegenüber `*.tfvars` zu haben

Weitere Informationen:

- [Variablen Datei](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

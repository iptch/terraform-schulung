# Terraform Schulung - Aufgabe 11

⚠️ Diese Aufgabe im in Aufgabe 9 erstellten Repository umsetzen ⚠️

In dieser Aufgabe geht es darum, dass die leere Pipeline, um `terraform init`, `terraform plan -out tfplan` und `terraform apply tfplan` erweitert wird. Damit erreichen wir, dass das Deployment vom lokalen Jumphost in eine Pipeline verschoben wird.

Folgende Ziele sind in dieser Aufgabe zu erreichen.

1. Erweiterung der Pipeline um *Init*, *Plan* und *Apply*
2. Ausführen der Pipeline und Deployment der Ressourcen (Testing)
3. Erstellung und Abschliessen des PR

Bevor wir starten, nochmals versichern, dass wir uns im Branch `feature/resource-and-pipeline-configuration` befinden.

<details>
<summary>Lösungshinweis</summary>

Mit `git status` wird der aktuelle Branch abgefrag.

```bash
On branch feature/resource-and-pipeline-configuration
nothing to commit, working tree clean
```
</details>
<br>

## Schritt 01 - Pipeline erweitern

Die Pipeline beinhaltet vier Steps:

1. Terraform Install
2. Terraform Init und Terraform Plan
3. Zwischenspeicherung der Plan-Datei
4. Terraform Apply

```YAML
# azure-pipelines.yml
trigger: none  # No automatic triggers

pr: none       # No PR triggers

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: TerraformInstaller@1
  inputs:
    terraformVersion: '1.11.4'

- script: |
    terraform init
    terraform plan -out=tfplan
  displayName: 'Terraform Init & Plan'

- publish: tfplan
  artifact: tfplan

- script: |
    terraform apply tfplan
  displayName: 'Terraform Apply'
```

Unter [Create and manage agent pools](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues) ist beschrieben für was der Pool verwendet wird. Als Terraform Version verwenden wir dieselbe, wie auf dem Jumphost. So stellen wir sicher, dass euer lokales Deployment kompatibel mit eurer Pipeline. Wenn die Terraform Version für die Entwicklung (Jumphost) erhöht wird, wird auch die Pipeline angepasst. 

## Schritt 02 - Pipeline testen

Mit `git add .` werden die letzten Änderungen zu Git hinzugefügt. Mit `git commit -m "Added pipeline configuration"` werden die Änderungen committed. Mit `git push origin` resp. `git push --set-upstream origin feature/resource-and-pipeline-configuration` pushen wir die Änderungen wieder nach Azure DevOps.

Wenn in eurem Repository wieder der Menüpunkt *Pipelines* ausgewählt wird, sehen wir dort noch die leere Pipeline aus Aufgabe 9. Um eure neuste Pipeline auszuführen, erstellen wir eine neue Pipeline und wählen aus eurem aktuellen Feature-Branch die `azure-pipelines.yml` Datei aus.

1. Im Menüpunkt *Pipelines* auf *New pipeline* klicken
2. *Azure Repos Git* auswählen
3. Euer Repository in der Liste auswählen
4. *Existing Azure Pipelines YAML file* auswählen
5. Beim *Branch* selektieren wir `feature/resource-and-pipeline-configuration` und beim *Path* `/azure-pipelines.yml`
6. Mit Klick auf *Run* führen wir die Pipeline aus.


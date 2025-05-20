# Terraform Workshop Agenda

## Tag 1: Grundlagen und erste Schritte mit Terraform

- 09:00 – 09:30 Begrüssung & Setup

  - Vorstellung des Trainers und der Teilnehmenden
  - Abklärung des Vorwissens der Teilnehmenden
  - Überblick über Workshop-Ziele & Ablauf
  - Technisches Setup: Azure Subscription, Terraform CLI, Code-Editor (z. B. VS Code), Azure CLI

- 09:30 – 10:30 Einführung in Terraform

  - Was ist Infrastructure as Code (IaC)?
  - Überblick über Terraform: Architektur, Hauptkonzepte (Providers, Resources, State)
  - Vergleich zu ARM, Bicep und anderen IaC-Tools
  - Aufbau einer Terraform-Datei (.tf)
  - Aufbau eines Terraform-Projekts
  - Vorstellung der Terraform Best Practices

  - Hands-on 1: Erste Terraform-Konfiguration lokal erstellen (ohne Azure)
    - **Ziel**: Einführung in die Syntax und Struktur von Terraform.
    - **Beispielkonfiguration**:
      ```hcl
      resource "local_file" "example" {
        filename = "example.txt"
        content  = "Hello, Terraform!"
      }
      ```
    - **Übungsschritte**:
      1. Installieren Sie Terraform CLI.
      2. Erstellen Sie die Datei `main.tf`.
      3. Führen Sie die Befehle `terraform init`, `terraform plan` und `terraform apply` aus.

- 10:30 – 10:45 Pause

- 10:45 – 12:15 Terraform mit Azure verbinden

  - Azure Provider & Authentifizierung
  - Ressourcenübersicht: Resource Group, Storage Account, Network, etc.
  - Terraform CLI-Befehle im Detail (init, plan, apply, destroy)

  - Hands-on 2: Erstellen einer Resource Group und eines Storage Accounts mit Terraform

    - **Ziel**: Verbindung zu Azure herstellen und erste Ressourcen erstellen.
    - **Beispielkonfiguration**:

      ```hcl
      provider "azurerm" {
        features {}
      }

      resource "azurerm_resource_group" "example" {
        name     = "example-resources"
        location = "West Europe"
      }

      resource "azurerm_storage_account" "example" {
        name                     = "examplestorageacct"
        resource_group_name      = azurerm_resource_group.example.name
        location                 = azurerm_resource_group.example.location
        account_tier             = "Standard"
        account_replication_type = "LRS"
      }
      ```

    - **Übungsschritte**:
      1. Authentifizieren Sie sich mit Azure CLI.
      2. Erstellen Sie die Datei `main.tf`.
      3. Führen Sie die Terraform-Befehle aus.

- 12:15 - 13:15 Mittagessen

- 13:15 – 14:30 Terraform State verstehen & verwalten

  - Bedeutung und Struktur des Terraform State
  - Lokaler vs. Remote State
  - State Locking & Azure Blob Backend

  - Hands-on 3: Umstellung auf Remote State mit Azure Blob Storage
    - **Ziel**: Verstehen und Implementieren eines Remote State Backends.
    - **Beispielkonfiguration**:
      ```hcl
      terraform {
        backend "azurerm" {
          resource_group_name  = "example-resources"
          storage_account_name = "examplestorageacct"
          container_name       = "tfstate"
          key                  = "terraform.tfstate"
        }
      }
      ```
    - **Übungsschritte**:
      1. Erstellen Sie ein Blob-Storage-Container in Azure.
      2. Konfigurieren Sie das Backend in `main.tf`.
      3. Führen Sie `terraform init` erneut aus.

- 14:30 – 15:30 Variablen, Outputs & Data Sources

  - Eingabevariablen (variables.tf)
  - Output-Werte
  - Verwendung von locals & data

  - Hands-on 4:

    - Parametrisierung der Konfiguration mit Variablen
    - **Ziel**: Einführung in Variablen und Outputs.
    - **Beispielkonfiguration**:

      ```hcl
      # variables.tf
      variable "location" {
        default = "West Europe"
      }

      # outputs.tf
      output "resource_group_name" {
        value = azurerm_resource_group.example.name
      }
      ```

    - **Übungsschritte**:
      1. Erstellen Sie die Dateien `variables.tf` und `outputs.tf`.
      2. Verwenden Sie die Variablen in der Hauptkonfiguration.

- 15:30 – 15:45 Pause

- 15:45 – 17:00 Projektstruktur & Best Practices

  - Strukturierung größerer Projekte
  - Modulübersicht & Wiederverwendbarkeit
  - Coding-Konventionen & Dokumentation

  - Hands-on 5: Refactoring der bisherigen Konfiguration in eine saubere Projektstruktur mit Variablen-Dateien
    - **Ziel**: Einführung in Best Practices und Projektstruktur.
    - **Beispielstruktur**:
      ```
      /project
      ├── main.tf
      ├── variables.tf
      ├── outputs.tf
      └── modules/
          └── storage/
              ├── main.tf
              ├── variables.tf
              └── outputs.tf
      ```
    - **Übungsschritte**:
      1. Refaktorieren Sie die Konfiguration in Module.
      2. Testen Sie die neue Struktur.

- 17:00 – 17:15 Q&A & Ausblick Tag 2

## Tag 2: Fortgeschrittene Themen

- 09:00 – 09:30 Rückblick & offene Fragen

- 09:30 – 10:30 Terraform Module in der Praxis

  - Warum Module?
  - Lokale vs. externe Module
  - Was sind Azure Verified Module (AVM)?
  - Struktur & Erstellung eigener Module
  - Wann keine Module verwenden?

  - Hands-on 6: Erstellung eines eigenen Moduls für ein Azure Storage Setup
    - **Ziel**: Einführung in Module und deren Wiederverwendbarkeit.
    - **Beispielmodul**:
      ```
      /modules/storage/
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
      ```
    - **Übungsschritte**:
      1. Erstellen Sie ein Modul für Storage Accounts.
      2. Verwenden Sie das Modul in der Hauptkonfiguration.

- 10:30 – 10:45 Pause

- 10:45 – 12:15 Komplexere Ressourcen & Abhängigkeiten

  - Netzwerke, Subnetze, Network Security Groups
  - Ressourcendependenzen & depends_on
  - Lebenszyklus-Steuerung (lifecycle Block)

  - Hands-on 7: Aufbau einer Netzwerkinfrastruktur mit NSG & Subnetzen

    - **Ziel**: Arbeiten mit komplexeren Ressourcen und Abhängigkeiten.
    - **Beispielkonfiguration**:

      ```hcl
      resource "azurerm_virtual_network" "example" {
        name                = "example-network"
        address_space       = ["10.0.0.0/16"]
        location            = var.location
        resource_group_name = azurerm_resource_group.example.name
      }

      resource "azurerm_subnet" "example" {
        name                 = "example-subnet"
        resource_group_name  = azurerm_resource_group.example.name
        virtual_network_name = azurerm_virtual_network.example.name
        address_prefixes     = ["10.0.1.0/24"]
      }
      ```

    - **Übungsschritte**:
      1. Erstellen Sie ein virtuelles Netzwerk mit Subnetzen.
      2. Fügen Sie eine Network Security Group hinzu.

- 12:15 - 13:15 Mittagessen

- 13:15 - 14:00 Einführung Git & CI/CD

  - Was ist Git?
  - Was sind die wichtigsten Befehle?
  - Wie sieht der ein einfacher Terraform-Development-Workflow aus?
  - Wie wird Azure DevOps Repos und Pipelines verwendet?

  - Hands-on 8:
    - In Azure DevOps ein Repo erstellen, auschecken und Branch erstellen
    - Leere Pipeline erstellen und ausführen

- 14:00 - 15:15 Terraform in Teams & mit Git

  - Arbeiten mit mehreren Entwicklern
  - GitOps & Git-Workflows
  - Versionierung von Modulen & Konfigurationen

  - Hands-on 9:
    - Nutzung eines Git-Repos mit mehreren Branches
    - Pull Requests und Review von Terraform Code

- 15:15 - 15:30 Pause

- 15:30 - 16:45 Terraform im CI/CD-Kontext

  - Integration in Azure DevOps Pipelines
  - Sicherheits- und Planungsüberlegungen
  - Beispiel-Pipeline mit Plan & Apply-Schritten

  - Hands-on 10 (optional / Demo): Erstellen einer einfachen CI/CD Pipeline mit Terraform Plan & Apply

    - **Ziel**: Integration von Terraform in eine CI/CD-Pipeline.
    - **Beispielpipeline**:

      ```yaml
      trigger:
        - main

      pool:
        vmImage: "ubuntu-latest"

      steps:
        - task: TerraformInstaller@0
          inputs:
            terraformVersion: "latest"

        - script: |
            terraform init
            terraform plan
          displayName: "Terraform Plan"
      ```

    - **Übungsschritte**:
      1. Erstellen Sie eine Pipeline mit `terraform plan` und `terraform apply`.

- 16:45 – 17:15 Abschluss & Ausblick
  - Zusammenfassung
  - Empfehlungen für weiterführende Ressourcen
  - Zertifizierungen (z. B. HashiCorp Certified Terraform Associate)
  - Feedbackrunde

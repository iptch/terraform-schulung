terraform {
  required_version = "1.10.4"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
output "workspace" {
  value = terraform.workspace
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}


resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

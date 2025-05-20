terraform {
  required_version = "~> 1.6"
}

output "hello_world" {
  value = local.hello_world
}

locals {
  hello_world = "${var.greeting} Welt!"
}

variable "greeting" {
  description = "Greeting message"
  type        = string
}

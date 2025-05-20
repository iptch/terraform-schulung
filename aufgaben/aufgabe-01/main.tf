terraform {
  required_version = "1.6.0"
}

locals {
  first  = local.second
  second = local.first
}

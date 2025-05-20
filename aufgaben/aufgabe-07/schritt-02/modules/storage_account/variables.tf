variable "suffix" {
  description = "Suffix for the naming module"
  type        = list(string)
  default     = ["workshop"]
}

variable "prefix" {
  description = "Prefix for the naming module"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "Location for the naming module"
  type        = string
  default     = "westeurope"
}

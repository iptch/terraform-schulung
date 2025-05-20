module "storage_account" {
  source = "./modules/storage_account"

  prefix   = []
  suffix   = ["workshop"]
  location = "westeurope"
}

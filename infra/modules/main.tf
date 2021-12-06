provider "google" {
  credentials = file(var.terraform_service_account_key_file)
  project     = var.project_id
  region      = var.region
}
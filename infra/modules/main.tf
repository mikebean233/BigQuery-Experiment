provider "google" {
  credentials = file(var.terraform_service_account_key_file)
  project     = var.project_id
  region      = var.region
}

module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  dataset_id                 = "temp_samples_ds_id"
  dataset_name               = "temp_samples_ds_name"
  description                = "BigQuery Experiment Dataset"
  project_id                 = var.project_id
  location                   = "US"
  delete_contents_on_destroy = true
  tables = [
    {
      table_id           = "temp_samples",
      schema             = file("../files/temp_samples_table_scheme.json"),
      time_partitioning  = null,
      range_partitioning = null,
      expiration_time    = 2524604400000, # 2050/01/01
      clustering         = [],
      labels = {
        table = "temp_samples"
      }
    }
  ]
  dataset_labels = {
    table = "temp_samples"
  }
}
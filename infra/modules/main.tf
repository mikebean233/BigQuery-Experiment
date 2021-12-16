provider "google" {
  credentials = file(var.terraform_service_account_key_file)
  project     = var.project_id
  region      = var.region
}

resource "google_bigquery_dataset" "tempSamplesDS" {
  dataset_id                  = "temp_samples_ds_id"
  friendly_name               = "temp_samples_ds_name"
  description                 = "BigQuery Experiment Dataset"
  location                    = "US"

  delete_contents_on_destroy = true
  labels = {
    table = "temp_samples"
  }
}

resource "google_bigquery_table" "tempSamplesTable" {
  dataset_id = google_bigquery_dataset.tempSamplesDS.dataset_id
  table_id   = "temp_samples"

  deletion_protection = false
  labels = {
    table = "temp_samples"
  }

  schema = file("../files/temp_samples_table_scheme.json")
}

data "google_iam_policy" "tempSamplesPolicy" {
  binding {
    role = var.update_data_role

    members = [
      "serviceAccount:${var.java_writer_sa_address}"
    ]
  }
}

resource "google_bigquery_table_iam_policy" "tempSamplesPolicy" {
  project = var.project_id
  dataset_id = google_bigquery_dataset.tempSamplesDS.dataset_id
  table_id = google_bigquery_table.tempSamplesTable.table_id
  policy_data = data.google_iam_policy.tempSamplesPolicy.policy_data

}

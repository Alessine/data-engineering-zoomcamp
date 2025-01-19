terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
# Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  credentials = "../terrademo/keys/my-creds.json"
  project = "dez-2025"
  region  = "europe-west6"
}



resource "google_storage_bucket" "homework_bucket" {
  name          = "dez_week1_homework_bucket"
  location      = "europe-west6"

  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "homework_dataset" {
  dataset_id = "homework_week1"
  project    = "dez-2025"
  location   = "europe-west6"
}
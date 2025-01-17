terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = "./keys/my-creds.json"
  project     = "dez-2025"
  region      = "europe-west6"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "dez-2025-terra-bucket"
  location      = "europe-west6"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.location
  credentials = var.credentials
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "${local.gcs_bucket_name}-1"
  location      = var.location
  force_destroy = true

  # Optional, but recommended settings:
  storage_class               = var.gcs_storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset_name
  project    = var.project_id
  location   = var.location
}
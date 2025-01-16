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
  project = "fleet-aleph-447822-a2"
  region  = "europe-west3-c"
  # credentials = "/workspaces/DataEngineering-2025/.ssh/terraform-runner-keys.json"
  credentials = "/workspaces/DataEngineering-2025/.ssh/fleet-aleph-447822-a2-editor-keys.json"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "fleet-aleph-447822-a2_demo-bucket"
  location      = "EU"
  force_destroy = true

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

}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "Terraform_dataset"
  project    = "fleet-aleph-447822-a2"
  location   = "EU"
}
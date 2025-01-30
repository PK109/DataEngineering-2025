variable "credentials" {
    description = "My GCP credentials file."
    # default = "/workspaces/DataEngineering-2025/.ssh/fleet-aleph-447822-a2-editor-keys.json"
    default = "/workspaces/DataEngineering-2025/.ssh/terraform-runner-keys.json" # alternative key 
  
}
variable "bq_dataset_name" {
  description = "My BigQuery dataset Name"
  default     = "taxi_dataset"
}



variable "project_id" {
  default = "fleet-aleph-447822-a2"
}

variable "location" {
  default = "europe-west3"
}

variable "gcs_storage_class" {
  default = "STANDARD"
}

locals {
  gcs_bucket_name = "${var.project_id}-${var.location}-taxi-storage"
}
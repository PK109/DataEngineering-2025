variable "credentials" {
    description = "My GCP credentials file."
    default = "/workspaces/DataEngineering-2025/.ssh/fleet-aleph-447822-a2-editor-keys.json"
    # default = "/workspaces/DataEngineering-2025/.ssh/terraform-runner-keys.json" # alternative key 
  
}
variable "bq_dataset_name" {
  description = "My BigQuery dataset Name"
  default     = "demo_dataset"
}

variable "project_id" {
  default = "fleet-aleph-447822-a2"
}

variable "location" {
  default = "eu"
}

variable "gcs_storage_class" {
  default = "STANDARD"
}
# variable "gcs_bucket_name" {
#   default = "${locals.project_id}-${locals.location}-bucket-name"
# }

locals {
  gcs_bucket_name = "${var.project_id}-${var.location}-bucket-name"
}
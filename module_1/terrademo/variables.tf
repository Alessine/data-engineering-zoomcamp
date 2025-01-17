variable "credentials" {
    description = "Credentials for project service account"
    default = "./keys/my-creds.json"
}
variable "project" {
    description = "Project ID"
    default = "dez-2025"
}
variable "location" {
    description = "Project Location"
    default = "europe-west6"
}
variable "bq_dataset_id" {
    description = "MY BigQuery Dataset ID"
    default = "example_dataset"
}
variable "gcs_bucket_name" {
    description = "MY Storage Bucket Name"
    default = "dez-2025-terra-bucket"
}
variable "gcp_storage_class" {
    description = "Bucket Storage Class"
    default = "STANDARD"
}
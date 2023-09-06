output "GCP_WORKLOAD_IDENTITY_PROVIDER" {
  value = google_iam_workload_identity_pool_provider.this.name
}

output "GCP_SERVICE_ACCOUNT" {
  value = google_service_account.this.email
}
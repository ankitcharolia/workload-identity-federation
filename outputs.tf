output "gcp_workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.this.name
}

output "gcp_service_account" {
  value = google_service_account.this.email
}
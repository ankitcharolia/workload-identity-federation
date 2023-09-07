# GCP Overview and Instructions
# https://cloud.google.com/iam/docs/configuring-workload-identity-federation#oidc

resource "google_iam_workload_identity_pool" "this" {
  project                   = var.project
  workload_identity_pool_id = "gitlab-ci"
  display_name              = "gitlab-ci"
  description               = "Workload Identity pool for GitLab-CI"
}

resource "google_iam_workload_identity_pool_provider" "this" {
  workload_identity_pool_id             = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id    = var.provider_id
  project                               = var.project
  attribute_mapping = {
    "google.subject"           = "assertion.sub", # Required
    "attribute.aud"            = "assertion.aud",
    "attribute.project_path"   = "assertion.project_path",
    "attribute.project_id"     = "assertion.project_id",
    "attribute.user_email"     = "assertion.user_email",
    "attribute.ref"            = "assertion.ref",
    "attribute.ref_type"       = "assertion.ref_type",
  }
  oidc {
    issuer_uri        = var.gitlab_url
  }
}

resource "google_service_account" "this" {
  project      = var.project
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
  description  = "[Gitlab-CI] ${var.service_account_description}"
}

resource "google_project_iam_member" "this" {
  project = var.project
  role    = var.role
  member  = "serviceAccount:${google_service_account.this.email}"
  depends_on = [
    google_service_account.this
  ]
}

resource "google_service_account_iam_binding" "this" {
  service_account_id = google_service_account.this.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.project_path/${var.gitlab_project_path}"
  ]
  depends_on = [
    google_service_account.this
  ]
}

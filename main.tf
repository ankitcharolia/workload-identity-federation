# GCP Overview and Instructions
# https://cloud.google.com/iam/docs/configuring-workload-identity-federation#oidc

resource "google_iam_workload_identity_pool" "gitlab_pool" {
  workload_identity_pool_id = "gitlab-ci"
  project                   = var.project
}

resource "google_iam_workload_identity_pool_provider" "gitlab_provider_jwt" {
  workload_identity_pool_id             = google_iam_workload_identity_pool.gitlab_pool.workload_identity_pool_id
  workload_identity_pool_provider_id    = "artifact-registry"
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
    allowed_audiences = [var.gitlab_url]
  }
}

resource "google_service_account" "gitlab_runner" {
  account_id   = "gitlab-ci"
  display_name = "[Gitlab-CI] Service Account for pushing the images to Google Artifact Registry"
}

resource "google_service_account_iam_binding" "gitlab_runner_oidc" {
  service_account_id = google_service_account.gitlab_runner.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab_pool.name}/attribute.project_id/${var.project}"
  ]
}


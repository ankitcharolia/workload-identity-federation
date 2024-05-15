# GCP Overview and Instructions
# https://cloud.google.com/iam/docs/configuring-workload-identity-federation#oidc

locals {
  roles = [
    "roles/owner",
    "rroles/storage.admin",
  ]
  # github_repository_name = "ankitcharolia/gcp-kube-services"
  gitlab_project_path = "ankitcharolia/gcp-kube-services"
}

resource "google_iam_workload_identity_pool" "this" {
  project                   = var.project
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = var.workload_identity_pool_display_name
  description               = "Workload Identity pool for GitLab-CI"
}

resource "google_iam_workload_identity_pool_provider" "this" {
  workload_identity_pool_id             = google_iam_workload_identity_pool.this.workload_identity_pool_id
  workload_identity_pool_provider_id    = var.workload_identity_pool_provider_id
  project                               = var.project
  attribute_mapping = {
    "google.subject"            = "assertion.sub", # Required
    "attribute.aud"             = "assertion.aud",
    "attribute.project_path"    = "assertion.project_path",
    "attribute.project_id"      = "assertion.project_id",
    "attribute.user_email"      = "assertion.user_email",
    "attribute.ref"             = "assertion.ref",
    "attribute.repository"      = "assertion.repository"
    "attribute.owner"           = "assertion.repository_owner"
    "attribute.ref_type"        = "assertion.ref_type",
  }
  oidc {
    # issuer_uri  = var.gitlab_repo_url
    issuer_uri  = var.github_issues_url
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
  for_each = {
    for role in local.roles : role => role
  }
  role    = each.value
  member  = "serviceAccount:${google_service_account.this.email}"
  depends_on = [
    google_service_account.this
  ]
}

# for gitlab-ci
resource "google_service_account_iam_binding" "this" {
  service_account_id = google_service_account.this.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.project_path/${local.gitlab_project_path}"
  ]
  depends_on = [
    google_service_account.this
  ]
}

# for github-actions
# resource "google_service_account_iam_binding" "this" {
#   service_account_id = google_service_account.this.name
#   role               = "roles/iam.workloadIdentityUser"

#   members = [
#     "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.this.name}/attribute.repository/${local.github_repository_name}"
#   ]
#   depends_on = [
#     google_service_account.this
#   ]
# }
variable "gitlab_repo_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "github_issues_url" {
  type    = string
  default = "https://token.actions.githubusercontent.com"
}

variable "workload_identity_pool_display_name" {
  type        = string
  description = "Display name for the Workload Identity Pool"
}

variable "workload_identity_pool_id" {
  type        = string
  description = "ID for the Workload Identity Pool"
}

variable "workload_identity_pool_provider_id" {
  type        = string
  description = "ID for the Workload Identity Pool Provider"
}

variable "gitlab_project_path" {
  type        = string
  description = "Project path to restrict authentication from"
}

variable "project" {
  type        = string
  description = "GCP Project name"
}

variable "service_account_name" {
  type = string
}

variable "service_account_description" {
  type = string
}

variable "service_account_display_name" {
  type = string
}

variable "service_account_role" {
  type = string
}

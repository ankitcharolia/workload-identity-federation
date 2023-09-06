variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_project_path" {
  type        = string
  description = "Project ID to restrict authentication from."
}

variable "project" {
  type        = string
  description = "GCP Project name"
}

variable "service_account" {
  type = string
}

variable "service_account_description" {
  type = string
}

variable "service_account_display_name" {
  type = string
}
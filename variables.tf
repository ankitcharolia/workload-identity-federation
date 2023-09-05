variable "gitlab_url" {
  type    = string
  default = "https://gitlab.com"
}

variable "gitlab_project_id" {
  type        = string
  description = "Project ID to restrict authentication from."
}

variable "project" {
  type        = string
  description = "GCP Project name"
}

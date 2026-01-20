variable "project_id" { type = string }
variable "region"     { type = string default = "us-east4" }

variable "agent_name" { type = string }

variable "tool_image" {
  description = "Artifact Registry image for agent tools"
  type        = string
  validation {
    condition     = length(trim(var.docker_image)) > 0
    error_message = "docker_image must be provided and cannot be empty."
  }

  validation {
    condition     = can(regex("^.+/.+:.+$", var.docker_image))
    error_message = "docker_image must include a tag (e.g., :v1.0.0)."
  }
}

variable "environment" {
  type        = string
  description = "dev | prod"
}

variable "agent_iam_roles" {
  description = "IAM roles required by the Vertex AI Agent service account"
  type        = list(string)
  default = [
    "roles/aiplatform.user",
    "roles/run.invoker",
    "roles/logging.logWriter"
  ]
}

variable "project_id" { type = string }
variable "region"     { type = string }

variable "agent_name" { type = string }

variable "tool_image" {
  description = "Artifact Registry image for agent tools"
  type        = string
  validation {
    condition     = length(trim(var.tool_image)) > 0
    error_message = "tool_image must be provided and cannot be empty."
  }

  validation {
    condition     = can(regex("^.+/.+:.+$", var.tool_image))
    error_message = "tool_image must include a tag (e.g., :v1.0.0)."
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

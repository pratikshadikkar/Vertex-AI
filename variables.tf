variable "project_id" { type = string }
variable "region"     { type = string default = "us-east4" }

variable "agent_name" { type = string }

variable "tool_image" {
  description = "Artifact Registry image for agent tools"
  type        = string
}

variable "environment" {
  type        = string
  description = "dev | prod"
}

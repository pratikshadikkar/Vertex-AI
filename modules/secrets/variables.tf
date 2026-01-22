variable "project_id" {
  type = string
}

variable "secrets" {
  description = "Map of secret names"
  type = map(object({
    replication = string # automatic | user-managed
  }))
}

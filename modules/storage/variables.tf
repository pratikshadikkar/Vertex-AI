variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "location" {
  type    = string
  default = "US"
}

variable "retention_days" {
  type    = number
  default = 90
}

variable "labels" {
  type    = map(string)
  default = {}
}

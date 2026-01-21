variable "project_id" { type = string }
variable "region"     { type = string }
variable "environment"{ type = string }
variable "index_name" { type = string }
variable "dimensions" { type = number }

variable "distance_measure" {
  type    = string
  default = "COSINE_DISTANCE"
}

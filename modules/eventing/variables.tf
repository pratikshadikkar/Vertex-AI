variable "project_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "topic_name" {
  type = string
}

variable "subscription_name" {
  type = string
}

variable "max_delivery_attempts" {
  type    = number
  default = 5
}

variable "ack_deadline_seconds" {
  type    = number
  default = 60
}

variable "labels" {
  type    = map(string)
  default = {}
}

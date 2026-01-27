resource "google_storage_bucket" "this" {
  project  = var.project_id
  name     = var.bucket_name
  location = var.location

  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = var.retention_days
    }
  }

  labels = var.labels
}

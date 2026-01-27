resource "google_pubsub_topic" "main" {
  project = var.project_id
  name    = var.topic_name
  labels  = var.labels
}

resource "google_pubsub_topic" "dlq" {
  project = var.project_id
  name    = "${var.topic_name}-dlq"
  labels  = var.labels
}

resource "google_pubsub_subscription" "main" {
  project = var.project_id
  name    = var.subscription_name
  topic   = google_pubsub_topic.main.name

  ack_deadline_seconds = var.ack_deadline_seconds

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dlq.id
    max_delivery_attempts = var.max_delivery_attempts
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  labels = var.labels
}

resource "google_storage_notification" "raw_object_events" {
  bucket         = var.bucket_name
  topic          = google_pubsub_topic.main.id
  payload_format = "JSON_API_V1"
  event_types    = ["OBJECT_FINALIZE"]
}

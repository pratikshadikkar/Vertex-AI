## Enable apis##
resource "google_project_service" "logging" {
  service = "logging.googleapis.com"
}

resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"
}
############################################
resource "google_logging_project_sink" "agent_sink" {
  name        = "vertex-agent-${var.environment}-sink"
  destination = "storage.googleapis.com/${var.project_id}-agent-logs"
  filter      = "resource.type=cloud_run_revision"
}

resource "google_logging_project_sink" "vertex_agent_sink" {
  name        = "vertex-agent-logs"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/vertex_logs"

  filter = <<EOT
resource.type="aiplatform.googleapis.com/Endpoint"
EOT
}

resource "google_logging_metric" "vertex_errors" {
  name        = "vertex_agent_error_count"
  description = "Count of Vertex AI Agent errors"

  filter = <<EOT
resource.type="aiplatform.googleapis.com/Endpoint"
severity>=ERROR
EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_logging_metric" "cloud_run_5xx" {
  name = "cloud_run_5xx_errors"

  filter = <<EOT
resource.type="cloud_run_revision"
httpRequest.status>=500
EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "vertex_error_alert" {
  display_name = "Vertex Agent Error Alert"

  combiner = "OR"

  conditions {
    display_name = "High error rate"

    condition_threshold {
      filter = <<EOT
metric.type="logging.googleapis.com/user/vertex_agent_error_count"
EOT

      comparison      = "COMPARISON_GT"
      threshold_value = 5
      duration        = "60s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
}
resource "google_monitoring_dashboard" "vertex_dashboard" {
  dashboard_json = file("${path.module}/dashboards/vertex.json")
}



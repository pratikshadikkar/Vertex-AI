resource "google_cloud_run_service" "agent_tools" {
  name     = "${var.agent_name}-tools-${var.environment}"
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "10"
      }
    }

    spec {
      service_account_name = google_service_account.agent_sa.email

      containers {
        image = var.tool_image

        env {
          name  = "AGENT_CONFIG_SECRET"
          value = google_secret_manager_secret.agent_config.secret_id

        }
        env {
          name = "LLM_API_KEY"
          value_source {
          secret_key_ref {
                secret  = "LLM_API_KEY"
                version = "latest"
           }
          }
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

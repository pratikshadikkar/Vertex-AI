resource "google_secret_manager_secret" "this" {
  for_each = var.secrets

  project   = var.project_id
  secret_id = each.key

  replication {
    automatic = each.value.replication == "automatic"
  }

  labels = {
    managed = "terraform"
  }
}

resource "google_secret_manager_secret_version" "config_v1" {
  secret = google_secret_manager_secret.agent_config.id
  secret_data = jsonencode({
    model       = "gemini-1.5-pro"
    temperature = 0.2
  })
}

# echo -n "real-api-key" | \
# gcloud secrets versions add LLM_API_KEY --data-file=-


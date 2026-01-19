resource "google_secret_manager_secret" "agent_config" {
  secret_id = "vertex-agent-config-${var.environment}"
  replication { automatic = true }
}

resource "google_secret_manager_secret_version" "config_v1" {
  secret = google_secret_manager_secret.agent_config.id
  secret_data = jsonencode({
    model       = "gemini-1.5-pro"
    temperature = 0.2
  })
}

resource "google_secret_manager_secret_iam_member" "access" {
  secret_id = google_secret_manager_secret.agent_config.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.agent_sa.email}"
}

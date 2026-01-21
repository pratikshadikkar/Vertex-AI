resource "google_service_account" "agent_sa" {
  account_id   = "${var.agent_name}-${var.environment}-sa"
  display_name = "Vertex Agent (${var.environment})"
}

resource "google_project_iam_member" "agent_roles" {
  for_each = toset(var.agent_iam_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.agent_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "agent_access" {
  for_each = toset(var.secret_ids)

  project   = var.project_id
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.agent_sa.email}"
}

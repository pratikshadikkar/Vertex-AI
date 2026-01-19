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

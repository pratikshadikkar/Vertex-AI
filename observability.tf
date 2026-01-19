resource "google_logging_project_sink" "agent_sink" {
  name        = "vertex-agent-${var.environment}-sink"
  destination = "storage.googleapis.com/${var.project_id}-agent-logs"
  filter      = "resource.type=cloud_run_revision"
}

outputs.tf
output "tool_service_url" {
  value = google_cloud_run_service.agent_tools.status[0].url
}

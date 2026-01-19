output "tool_service_url" {
  value = google_cloud_run_service.agent_tools.status[0].url
}

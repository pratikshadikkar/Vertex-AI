module "vertex-agent" {
  source = "../terraform/modules"

  project_id        = "my-sandbox-project"
  region            = "us-east4"
  agent_name        = "devops-assistant"
  env               = "dev"
  tool_image = "us-docker.pkg.dev/my-project/tools/agent-tools:latest"
}
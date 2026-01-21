module "vector_search" {
  source      = "../modules/vector-search"
  project_id  = var.project_id
  region      = "us-east4"
  environment = "dev"

  index_name = "enterprise-knowledge"
  dimensions = 768
}

module "vertex_agent" {
  source      = "../modules/vertex-agent"
  project_id  = var.project_id
  region      = "us-east4"
  environment = "dev"

  agent_name         = "knowledge-agent"
  tool_image       = "us-east4-docker.pkg.dev/proj/agents/agent:v1"
  vector_endpoint_id = module.vector_search.index_endpoint_id
}

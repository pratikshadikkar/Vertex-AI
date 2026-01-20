run "vertex_agent_unit_test" {

  command = plan

  module {
    source = "../terraform/modules"

    project_id   = "test-project"
    environment  = "dev"
    agent_name   = "vertex-agent"

    iam_roles = [
      "roles/aiplatform.user",
      "roles/run.invoker",
      "roles/logging.logWriter"
    ]
  }
  # Test: Service account name
  assert {
    condition     = google_service_account.agent_sa.account_id == "vertex-agent-dev-sa"
    error_message = "Service account naming is incorrect"
  }

  # Test: IAM roles count
  assert {
    condition     = length(google_project_iam_member.agent_roles) == 3
    error_message = "Expected exactly 3 IAM roles"
  }

  # Test: Required IAM role exists
  assert {
    condition     = contains(keys(google_project_iam_member.agent_roles), "roles/aiplatform.user")
    error_message = "Vertex AI user role missing"
  }
}

run "cloudrun_missing_image_should_fail" {

  command = plan

  module {
    source = "../terraform/modules"

    tool_image = ""   #  intentionally missing
  }

  expect_failures = [
    var.tool_image
  ]
}

run "cloudrun_invalid_image_format" {

  command = plan

  module {
    source = "../terraform/modules"

    tool_image = "gcr.io/my-project/agent" #  no tag
  }

  expect_failures = [
    var.tool_image
  ]
}

run "cloudrun_valid_image" {

  command = plan

  module {
    source = "../modules/vertex-agent"

    tool_image = "us-east4-docker.pkg.dev/my-proj/agents/vertex-agent:v1.0.0"
  }

  assert {
    condition     = google_cloud_run_v2_service.agent.template[0].containers[0].image != ""
    error_message = "Cloud Run image should not be empty"
  }
}



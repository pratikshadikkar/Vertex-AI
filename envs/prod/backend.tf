terraform {
  backend "gcs" {
    bucket  = "vertex-terraform-state"
    prefix  = "pipelines/prod"
  }
}

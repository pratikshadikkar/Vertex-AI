module "raw_bucket" {
  source        = "../../modules/storage"
  project_id   = var.project_id
  bucket_name  = "raw-data-${var.env}"
  retention_days = 180

  labels = {
    layer = "raw"
    env   = var.env
  }
}

module "staging_bucket" {
  source       = "../../modules/storage"
  project_id  = var.project_id
  bucket_name = "staging-data-${var.env}"

  labels = {
    layer = "staging"
    env   = var.env
  }
}

module "processed_bucket" {
  source       = "../../modules/storage"
  project_id  = var.project_id
  bucket_name = "processed-data-${var.env}"

  labels = {
    layer = "processed"
    env   = var.env
  }
}

module "raw_eventing" {
  source = "../../modules/eventing"

  project_id = var.project_id
  bucket_name = module.raw_bucket.bucket_name

  topic_name        = "raw-data-events-${var.env}"
  subscription_name = "raw-data-orchestrator-${var.env}"

  labels = {
    layer = "eventing"
    env   = var.env
  }
}


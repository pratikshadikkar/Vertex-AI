resource "google_vertex_ai_index" "this" {
  project      = var.project_id
  region       = var.region
  display_name = "${var.index_name}-${var.environment}"

  metadata {
    contents_delta_uri = "gs://${var.project_id}-vector-data/${var.environment}/"

    config {
      dimensions       = var.dimensions
      distance_measure = var.distance_measure

      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count   = 500
          leaf_nodes_to_search_percent = 7
        }
      }
    }
  }

  labels = {
    env     = var.environment
    managed = "terraform"
  }
}

resource "google_vertex_ai_index_endpoint" "this" {
  project      = var.project_id
  region       = var.region
  display_name = "${var.index_name}-endpoint-${var.environment}"
}

resource "google_vertex_ai_index_endpoint_deployed_index" "this" {
  index_endpoint    = google_vertex_ai_index_endpoint.this.id
  index             = google_vertex_ai_index.this.id
  deployed_index_id = "${var.index_name}-${var.environment}-deployed"

  automatic_resources {
    min_replica_count = 1
    max_replica_count = 3
  }
}

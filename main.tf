data google_project default {

}

resource google_cloud_run_service default {
  name = var.name
  location = var.location
  autogenerate_revision_name = true

  template {
    spec {
      container_concurrency = var.concurrency
      timeout_seconds = var.timeout
      service_account_name = var.service_account_email

      containers {
        image = var.image

        ports {
          container_port = var.port
        }

        resources {
          limits = {
            cpu = "${var.cpus * 1000}m"
            memory = "${var.memory}Mi"
          }
        }

        dynamic "env" {
          for_each = var.env

          content {
            name = env.key
            value = env.value
          }
        }
      }
    }

    metadata {
      annotations = merge(
        {
          "run.googleapis.com/cloudsql-instances" = join(",", var.cloudsql_connections)
          "autoscaling.knative.dev/maxScale" = var.max_instances
        },
        var.vpc_connector_name == null ? {} : {
          "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
          "run.googleapis.com/vpc-access-egress" = var.vpc_access_egress
        }
      )
    }
  }

  traffic {
    percent = 100
    latest_revision = var.revision == null
    revision_name = var.revision
  }
}


resource google_cloud_run_service_iam_member public_access {
  count = var.allow_public_access ? 1 : 0
  service = google_cloud_run_service.default.name
  location = google_cloud_run_service.default.location
  role = "roles/run.invoker"
  member = "allUsers"
}

resource google_cloud_run_domain_mapping domains {
  for_each = var.map_domains

  location = google_cloud_run_service.default.location
  name = each.value

  metadata {
    namespace = data.google_project.default.project_id
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  spec {
    route_name = google_cloud_run_service.default.name
  }

  lifecycle {
    ignore_changes = [metadata[0]]
  }
}

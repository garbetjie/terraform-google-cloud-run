output name {
  value = google_cloud_run_service.default.name
  description = "Name of the service."
}

output image {
  value = google_cloud_run_service.default.metadata[0].annotations["client.knative.dev/user-image"]
  description = "Docker image name."
}

output location {
  value = google_cloud_run_service.default.location
  description = "Location of the service."
}

output allow_public_access {
  value = var.allow_public_access
  description = "Allow unauthenticated access to the service."
}

output args {
  value = google_cloud_run_service.default.template[0].spec[0].containers[0].args
  description = "Arguments passed to the entrypoint."
}

output cloudsql_connections {
  value = var.cloudsql_connections
  description = "Cloud SQL connections attached to container instances."
}

output concurrency {
  value = google_cloud_run_service.default.template[0].spec[0].container_concurrency
  description = "Maximum allowed concurrent requests per container for the created revision."
}

output cpu_throttling {
  value = var.cpu_throttling
  description = "Configuration for CPU throttling outside of request processing."
}

output cpus {
  value = var.cpus
  description = "Number of CPUs allocated per container."
}

output cpus_suffixed {
  value = google_cloud_run_service.default.template[0].spec[0].containers[0].resources[0].limits.cpu
  description = "CPUs allocated per container, specified with the millicpu suffix (eg: \"1000m\" if `var.cpus` is 1)."
}

output entrypoint {
  value = google_cloud_run_service.default.template[0].spec[0].containers[0].command
  description = "Entrypoint command used in the service."
}

output env {
  value = [
    for env in local.env: {
      key = env.key
      value = env.value
      secret = env.secret.name
      version = env.secret.name != null ? env.secret.version : null
    }
  ]
  description = "Environment variables injected into container instances."
}

output execution_environment {
  value = google_cloud_run_service.default.template[0].metadata[0].annotations["run.googleapis.com/execution-environment"]
  description = "Execution environment container instances are running under."
}

output http2 {
  value = var.http2
  description = "Status of HTTP/2 end-to-end handling."
}

output ingress {
  value = google_cloud_run_service.default.metadata[0].annotations["run.googleapis.com/ingress"]
  description = "Ingress settings applied to the service."
}

output labels {
  value = var.labels
  description = "Labels applied to the service."
}

output map_domains {
  value = var.map_domains
  description = "Domain names mapped to the service."
}

output max_instances {
  value = tonumber(google_cloud_run_service.default.template[0].metadata[0].annotations["autoscaling.knative.dev/maxScale"])
  description = "Maximum number of container instances allowed to start."
}

output memory {
  value = var.memory
  description = "Memory (in Mi) allocated to container instances."
}

output memory_suffixed {
  value = google_cloud_run_service.default.template[0].spec[0].containers[0].resources[0].limits.memory
  description = "Memory allocated to containers instances, with the relevant suffix (eg: \"256Mi\" if `var.memory` is 256)."
}

output min_instances {
  value = tonumber(google_cloud_run_service.default.template[0].metadata[0].annotations["autoscaling.knative.dev/minScale"])
  description = "Minimum number of container instances to keep running."
}

output port {
  value = google_cloud_run_service.default.template[0].spec[0].containers[0].ports[0].container_port
  description = "Port on which the container is listening for incoming HTTP requests."
}

output project {
  value = google_cloud_run_service.default.project
  description = "Google Cloud project in which resources were created."
}

output revision {
  value = var.revision
  description = "Revision name that was created."
}

output service_account_email {
  value = google_cloud_run_service.default.template[0].spec[0].service_account_name != "" ? google_cloud_run_service.default.template[0].spec[0].service_account_name : null
  description = "IAM service account email to assigned to container instances."
}

output timeout {
  value = tonumber(google_cloud_run_service.default.template[0].spec[0].timeout_seconds)
  description = "Maximum duration (in seconds) allowed for responding to requests."
}

output volumes {
  value = toset([
    for vol in local.volumes: {
      path = vol.path
      secret = vol.secret.name
      versions = {
        for item in vol.items: item.filename => item.version
      }
    }
  ])

  description = "Secrets mounted as volumes into the service."
}

output vpc_access {
  value = {
    connector = lookup(google_cloud_run_service.default.template[0].metadata[0].annotations, "run.googleapis.com/vpc-access-connector", null)
    egress = lookup(google_cloud_run_service.default.template[0].metadata[0].annotations, "run.googleapis.com/vpc-access-egress", null)
  }
  description = "VPC access configuration."
}

// --

output latest_ready_revision_name {
  value = google_cloud_run_service.default.status[0].latest_ready_revision_name
  description = "Latest revision ready for use."
}

output latest_created_revision_name {
  value = google_cloud_run_service.default.status[0].latest_created_revision_name
  description = "Last revision created."
}

output url {
  value = google_cloud_run_service.default.status[0].url
  description = "URL at which the service is available."
}

output id {
  value = google_cloud_run_service.default.id
  description = "ID of the created service."
}

output dns {
  value = {
    for domain, records in {
      for domain in var.map_domains: domain => {
        for record in google_cloud_run_domain_mapping.domains[domain].status[0].resource_records:
          "${record.type}/${record.name}" => record.rrdata...
        }
    }: domain => [
      for type_and_name, rrdatas in records: {
        name = split("/", type_and_name)[1] == "" ? null : split("/", type_and_name)[1]
        root = trimprefix(domain, "${split("/", type_and_name)[1]}.")
        type = split("/", type_and_name)[0]
        rrdatas = toset(rrdatas)
      }
    ]
  }

  description = "DNS records to populate for mapped domains. Keys are the domains that are mapped."
}
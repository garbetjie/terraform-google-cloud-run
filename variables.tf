variable name {
  type = string
  description = "Name of the Cloud Run service."
}

variable image {
  type = string
  description = "GCR-hosted image to deploy to the service."
}

variable location {
  type = string
  description = "Location in which to run the service."
}

variable allow_public_access {
  type = bool
  default = true
  description = "Allow non-authenticated access to the service."
}

variable memory {
  type = number
  default = 256
  description = "Memory (in MB) to allocate to service instances."
}

variable project {
  type = string
  default = null
  description = "Google Cloud project in which to create the service."
}

variable cpus {
  type = number
  default = 1
  description = "CPUs to allocate to service instances."
}

variable cloudsql_connections {
  type = list(string)
  default = []
  description = "Cloud SQL connections to attach to service instances."
}

variable revision {
  type = string
  default = null
  description = "Revision name to create and deploy."
}

variable timeout {
  type = number
  default = 60
  description = "Length of time (in seconds) to allow requests to run for."
}

variable concurrency {
  type = number
  default = null
  description = "Maximum number of requests a single service instance can handle at once."
}

variable max_instances {
  type = number
  default = 1000
  description = "Maximum number of service instances to allow to start."
}

variable min_instances {
  type = number
  default = 0
  description = "Minimum number of service instances to keep running."
}

variable service_account_email {
  type = string
  default = null
  description = "Service account email to assign to the service."
}

variable map_domains {
  type = set(string)
  default = []
  description = "Domain names to map to this service instance."
}

variable env {
  type = map(string)
  default = {}
  description = "Environment variables to inject into the service instance."
}

variable vpc_connector_name {
  type = string
  default = null
  description = "VPC connector to apply to this service."
}

variable vpc_access_egress {
  type = string
  default = "private-ranges-only"
  description = "Specify whether to divert all outbound traffic through the VPC, or private ranges only."
}

variable port {
  type = number
  default = 8080
  description = "Port on which the container is listening for incoming HTTP requests."
}

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

variable labels {
  type = map(string)
  default = {}
  description = "Labels to apply to the service."
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
  type = set(
    object({
      key = string,
      value = optional(string),
      secret = optional(string),
      version = optional(string),
    })
  )

  default = []
  description = "Environment variables to inject into the service instance."

  validation {
    error_message = "Environment variables must have one of `value` or `secret` defined."
    condition = alltrue([
      length([for e in var.env: e if (e.value == null && e.secret == null)]) < 1,
      length([for e in var.env: e if (e.value != null && e.secret != null)]) < 1,
    ])
  }
}

variable args {
  type = list(string)
  default = []
  description = "Arguments to the service's entrypoint."
}

variable entrypoint {
  type = list(string)
  default = []
  description = "Entrypoint command. Defaults to the image's ENTRYPOINT if not provided."
}

variable volumes {
  type = set(object({ path = string, secret = string, versions = optional(map(string)) }))
  default = []
  description = "Secrets to mount as volumes into the service."

  validation {
    error_message = "Multiple volumes for the same path can't be defined."
    condition = length(tolist(var.volumes.*.path)) == length(toset(var.volumes.*.path))
  }
}

variable vpc_access {
  type = object({ connector = optional(string), egress = optional(string) })
  default = { connector = null, egress = null }
  description = "Control VPC access for the Cloud Run service."

  validation {
    error_message = "VPC access egress must be one of the following values: [\"all-traffic\", \"private-ranges-only\"]."
    condition = var.vpc_access.connector != null && (var.vpc_access.egress == null || contains(["all-traffic", "private-ranges-only"], coalesce(var.vpc_access.egress, "-")))
  }
}

variable vpc_connector_name {
  type = string
  default = null
  description = "VPC connector to apply to this service (Deprecated - use `var.vpc_access.connector` instead)."
}

variable vpc_access_egress {
  type = string
  default = "private-ranges-only"
  description = "Specify whether to divert all outbound traffic through the VPC, or private ranges only (Deprecated - use `var.vpc_access.egress` instead)."
}

variable port {
  type = number
  default = 8080
  description = "Port on which the container is listening for incoming HTTP requests."
}

variable ingress {
  type = string
  default = "all"
  description = "Restrict network access to this service. Allowed values: [`all`, `internal`, `internal-and-cloud-load-balancing`]"

  validation {
    error_message = "Ingress must be one of: [\"all\", \"internal\", \"internal-and-cloud-load-balancing\"]."
    condition = contains(["all", "internal", "internal-and-cloud-load-balancing"], var.ingress)
  }
}

variable name {
  type = string
}

variable image {
  type = string
}

variable location {
  type = string
}

variable allow_public_access {
  type = bool
  default = true
}

variable memory {
  type = number
  default = 256
}

variable cpus {
  type = number
  default = 1
}

variable cloudsql_connections {
  type = list(string)
  default = []
}

variable revision {
  type = string
  default = null
}

variable timeout {
  type = number
  default = 60
}

variable concurrency {
  type = number
  default = null
}

variable max_instances {
  type = number
  default = 1000
}

variable service_account_email {
  type = string
  default = null
}

variable map_domains {
  type = set(string)
  default = []
}

variable env {
  type = map(string)
  default = {}
}

variable vpc_connector_name {
  type = string
  default = null
}

variable vpc_access_egress {
  type = string
  default = "private-ranges-only"
}

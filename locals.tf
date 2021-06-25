locals {
  project_id = var.project

  # Fill in defaults for environment variables.
  env = toset([
    for e in var.env: {
      key = e.key
      value = e.value
      secret = {
        name = e.secret
        alias = e.secret != null ? lookup(local.secrets_to_aliases, e.secret, null) : null
      }
      version = coalesce(e.version, "latest")
    }
  ])

  // Fill in defaults for volumes.
  volumes = toset([
    for vol in var.volumes: {
      path = vol.path
      name = "volume-${substr(sha1(jsonencode(vol)), 0, 4)}"
      secret = {
        name = vol.secret
        alias = lookup(local.secrets_to_aliases, vol.secret, null)
      }
      items = [
        for filename, version in coalesce(vol.versions, { latest = "latest" }): {
          filename = filename,
          version = version
        }
      ]
    }
  ])

  // Map secrets in other projects to aliases. This allows for easy lookup when building up `local.env` and `local.volumes`.
  secrets_to_aliases = {
    for secret in distinct(concat(
        [for env in var.env: env.secret if env.secret != null],
        [for vol in var.volumes: vol.secret if vol.secret != null]
      )):
      secret => "secret-${substr(sha1(secret), 0, 4)}"
    if length(split("/", secret)) > 1
  }

  // It seems like a BETA launch stage is still okay for functionality in PREVIEW.
//  launch_stage = length(local.volumes) > 0 || local.env_from_secrets_count > 0 ? "BETA" : "BETA"
  launch_stage = "BETA"

  // Ensure backwards-compatibility for the change in VPC access variables.
  vpc_access = {
    connector = coalesce(var.vpc_access.connector, var.vpc_connector_name, "-") == "-" ? null : coalesce(var.vpc_access.connector, var.vpc_connector_name)
    egress = coalesce(var.vpc_access.egress, var.vpc_access_egress, "private-ranges-only")
  }
}
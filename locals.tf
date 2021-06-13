locals {
  project_id = var.project_id

  # Fill in defaults for environment variables.
  env = [
    for e in var.env: {
      env = e.env
      value = e.value
      secret = e.secret
      version = coalesce(e.version, "latest")
    }
  ]
}
terraform {
  experiments = [module_variable_optional_attrs]
  required_version = ">= 0.14"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 3.67.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 3.67.0"
    }
  }
}
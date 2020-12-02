Terraform Module: Google Cloud Run
==================================

A Terraform module for [Google Cloud](https://cloud.google.com) that simplifies the creation of a Cloud Run instance.

## Basic usage

```hcl-terraform
module cloud_run_www {
  source = "garbetjie/cloud-run/google"
  name = "my-service"
  image = "gcr.io/my-project/grafana:latest"
  location = "europe-west4"
  allow_public_access = true
  port = 3000
}
```

> Documentation will be added soon regarding inputs & outputs.

Terraform Module: Google Cloud Run
==================================

A Terraform module for [Google Cloud](https://cloud.google.com) that simplifies the creation of a Cloud Run (Fully Managed)
service.

## Basic usage

```hcl-terraform
module cloud_run {
  source = "garbetjie/cloud-run/google"
  name = "my-service"
  image = "gcr.io/my-project/grafana:latest"
  location = "europe-west4"
  allow_public_access = true
  port = 3000
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [google_cloud_run_domain_mapping](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) |
| [google_cloud_run_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) |
| [google_cloud_run_service_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) |
| [google_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_public\_access | Allow non-authenticated access to the service. | `bool` | `true` | no |
| cloudsql\_connections | Cloud SQL connections to attach to service instances. | `list(string)` | `[]` | no |
| concurrency | Maximum number of requests a single service instance can handle at once. | `number` | `null` | no |
| cpus | CPUs to allocate to service instances. | `number` | `1` | no |
| env | Environment variables to inject into the service instance. | `map(string)` | `{}` | no |
| image | GCR-hosted image to deploy to the service. | `string` | n/a | yes |
| labels | Labels to apply to the service. | `map(string)` | `{}` | no |
| location | Location in which to run the service. | `string` | n/a | yes |
| map\_domains | Domain names to map to this service instance. | `set(string)` | `[]` | no |
| max\_instances | Maximum number of service instances to allow to start. | `number` | `1000` | no |
| memory | Memory (in MB) to allocate to service instances. | `number` | `256` | no |
| min\_instances | Minimum number of service instances to keep running. | `number` | `0` | no |
| name | Name of the Cloud Run service. | `string` | n/a | yes |
| port | Port on which the container is listening for incoming HTTP requests. | `number` | `8080` | no |
| project | Google Cloud project in which to create the service. | `string` | `null` | no |
| revision | Revision name to create and deploy. | `string` | `null` | no |
| service\_account\_email | Service account email to assign to the service. | `string` | `null` | no |
| service\_ingress | Use ingress settings to restrict network access to this service. Available ingress settings: `all`, `internal` or `internal-and-cloud-load-balancing`. | `string` | `"all"` | no |
| timeout | Length of time (in seconds) to allow requests to run for. | `number` | `60` | no |
| vpc\_access\_egress | Specify whether to divert all outbound traffic through the VPC, or private ranges only. | `string` | `"private-ranges-only"` | no |
| vpc\_connector\_name | VPC connector to apply to this service. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns | DNS records to populate for mapped domains. Keys are the domains that are mapped. |
| labels | Labels applied to the created service. |
| name | Name of the created service. |
| project | Google Cloud project in which the service was created. |
| revision | Deployed revision for the service. |
| url | The URL on which the deployed service is available. |

## Changelog

* **1.2.0**
    * Add `labels` input variable - to apply custom [labels](https://cloud.google.com/run/docs/configuring/labels) to the Cloud Run service
  
* **1.1.0**
    * Add `project` variable, to be able to specify the project in which to create the Cloud Run service.

* **1.0.0**
    * Release stable version.
    * Add BETA launch-stage to service (fixes inability to use `min_instances`).

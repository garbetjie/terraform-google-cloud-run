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

## Inputs

| Name                  | Description                                                                                                       | Type         | Default                 | Required |
|-----------------------|-------------------------------------------------------------------------------------------------------------------|--------------|-------------------------|----------|
| name                  | Name of the Cloud Run service.                                                                                    | string       |                         | Yes      |
| image                 | GCR-hosted image to deploy to the service.                                                                        | string       |                         | Yes      |
| location              | Location in which to run the service.                                                                             | string       |                         | Yes      |
| allow_public_access   | Allow non-authenticated access to the service.                                                                    | bool         | `true`                  | No       |
| cloudsql_connections  | Cloud SQL connections to attach to service instances.                                                             | list(string) | `[]`                    | No       |
| concurrency           | Maximum number of requests a single service instance can handle at once.                                          | number       | `null`                  | No       |
| cpus                  | CPUs to allocate to service instances.                                                                            | number       | `1`                     | No       |
| env                   | Environment variables to inject into the service instance.                                                        | map(string)  | `{}`                    | No       |
| ingress               | Restrict network access to this service. Allowed values: [`all`, `internal`, `internal-and-cloud-load-balancing`] | string       | `all`                   | No       |
| labels                | Map of [labels](https://cloud.google.com/run/docs/configuring/labels) to apply to the service.                    | map(string)  | `{}`                    | No       |
| map_domains           | Domain names to map to this service instance.                                                                     | set(string)  | `[]`                    | No       |
| max_instances         | Maximum number of service instances to allow to start.                                                            | number       | `1000`                  | No       |
| memory                | Memory (in MB) to allocate to service instances.                                                                  | number       | `256`                   | No       |
| min_instances         | Minimum number of service instances to keep running.                                                              | number       | `0`                     | No       |
| port                  | Port on which the container is listening for incoming HTTP requests.                                              | number       | `8080`                  | No       |
| project               | Google Cloud project in which to create the service.                                                              | string       | `null`                  | No       |
| revision              | Revision name to create and deploy. When `null`, revision names are automatically generated.                      | string       | `null`                  | No       |
| service_account_email | Service account email to assign to the service.                                                                   | string       | `null`                  | No       |
| timeout               | Length of time (in seconds) to allow requests to run for.                                                         | number       | `60`                    | No       |
| vpc_access_egress     | Specify whether to divert all outbound traffic through a VPC, or private ranges only.                             | string       | `"private-ranges-only"` | No       |
| vpc_connector_name    | VPC connector to apply to this service.                                                                           | string       | `null`                  | No       |

## Outputs

| Name     | Description                                                                       | Type                                                                  |
|----------|-----------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| dns      | DNS records to populate for mapped domains. Keys are the domains that are mapped. | map(object({ type = string, name = string, rrdatas = list(string) })) |
| id       | Identifier for the created service.                                               | string                                                                |
| labels   | Labels applied to the created service.                                            | map(string)                                                           |
| location | Location in which the Cloud Run service was created.                              | string                                                                |
| name     | Name of the created service.                                                      | string                                                                |
| project  | Google Cloud project in which the service was created.                            | string                                                                |
| revision | Deployed revision for the service.                                                | string                                                                |
| url      | The URL on which the deployed service is available.                               | string                                                                |

## Changelog

* **1.4.0**
    * Ignore additional annotations in order to prevent unnecessary diffs:
      * `run.googleapis.com/sandbox`
      * `serving.knative.dev/creator`
      * `serving.knative.dev/lastModifier`
    * Add outputs `location` and `id`.

* **1.3.0**
    * Add `ingress` input variable - to specify the level of network access restriction on the service.

* **1.2.0**
    * Add `labels` input variable - to apply custom [labels](https://cloud.google.com/run/docs/configuring/labels) to the Cloud Run service
  
* **1.1.0**
    * Add `project` variable, to be able to specify the project in which to create the Cloud Run service.

* **1.0.0**
    * Release stable version.
    * Add BETA launch-stage to service (fixes inability to use `min_instances`).

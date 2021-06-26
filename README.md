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

### Required inputs

| Name                  | Description                                                                                                                                                                        | Type                                                                                                           | Default                               | Required |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------|----------|
| name                  | Name of the Cloud Run service.                                                                                                                                                     | string                                                                                                         |                                       | Yes      |
| image                 | Image to deploy to the service. Must be hosted in Google Container Registry or Artifact Registry.                                                                                  | string                                                                                                         |                                       | Yes      |
| location              | Location in which to run the service.                                                                                                                                              | string                                                                                                         |                                       | Yes      |


### Optional inputs

| Name                  | Description                                                                                                                                                                        | Type                                                                                                           | Default                               | Required |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------|----------|
| allow_public_access   | Allow non-authenticated access to the service.                                                                                                                                     | bool                                                                                                           | `true`                                | No       |
| args                  | Arguments to pass to the service's entrypoint command.                                                                                                                             | list(string)                                                                                                   | `[]`                                  | No       |
| cloudsql_connections  | Cloud SQL connections to attach to service instances.                                                                                                                              | set(string)                                                                                                    | `[]`                                  | No       |
| concurrency           | Maximum number of requests a single service instance can handle at once.                                                                                                           | number                                                                                                         | `null`                                | No       |
| cpus                  | CPUs to allocate to service instances.                                                                                                                                             | number                                                                                                         | `1`                                   | No       |
| entrypoint            | Entrypoint command. Defaults to the image's ENTRYPOINT if not provided.                                                                                                            | list(string)                                                                                                   | `[]`                                  | No       |
| env                   | Environment variables to inject into the service instance. Exactly one of `value` or `secret` must be specified.                                                                   | set(object({ key = string, value = optional(string), secret = optional(string), version = optional(string) })) | `[]`                                  | No       |
| env.*.key             | Name of the environment variable to populate.                                                                                                                                      | string                                                                                                         |                                       | Yes      |
| env.*.value           | Value to populate the environment variable with.                                                                                                                                   | optional(string)                                                                                               | `null`                                | No       |
| env.*.secret          | Name of a secret to populate the environment variable with. Secrets in other projects should use the `projects/{{project}}/secrets/{{secret}}` format.                             | optional(string)                                                                                               | `null`                                | No       |
| env.*.version         | Version to use when populating with a secret. Defaults to the latest version.                                                                                                      | string                                                                                                         | `"latest"`                            | No       |
| ingress               | Restrict network access to this service. Allowed values: [`all`, `internal`, `internal-and-cloud-load-balancing`]                                                                  | string                                                                                                         | `all`                                 | No       |
| labels                | Map of [labels](https://cloud.google.com/run/docs/configuring/labels) to apply to the service.                                                                                     | map(string)                                                                                                    | `{}`                                  | No       |
| map_domains           | Domain names to map to this service instance.                                                                                                                                      | set(string)                                                                                                    | `[]`                                  | No       |
| max_instances         | Maximum number of service instances to allow to start.                                                                                                                             | number                                                                                                         | `1000`                                | No       |
| memory                | Memory (in MB) to allocate to service instances.                                                                                                                                   | number                                                                                                         | `256`                                 | No       |
| min_instances         | Minimum number of service instances to keep running.                                                                                                                               | number                                                                                                         | `0`                                   | No       |
| port                  | Port on which the container is listening for incoming HTTP requests.                                                                                                               | number                                                                                                         | `8080`                                | No       |
| project               | Google Cloud project in which to create the service.                                                                                                                               | string                                                                                                         | `null`                                | No       |
| revision              | Revision name to create and deploy. When `null`, revision names are automatically generated.                                                                                       | string                                                                                                         | `null`                                | No       |
| service_account_email | Service account email to assign to the service.                                                                                                                                    | string                                                                                                         | `null`                                | No       |
| timeout               | Length of time (in seconds) to allow requests to run for.                                                                                                                          | number                                                                                                         | `60`                                  | No       |
| volumes               | Volumes to be mounted & populated from existing [secrets](https://cloud.google.com/secret-manager).                                                                                | set(object({ path = string, secret = string, versions = optional(map(string)) }))                              | `[]`                                  | No       |
| volumes.*.path        | Path into which the secret will be mounted. The same path cannot be specified for multiple volumes.                                                                                | string                                                                                                         |                                       | Yes      |
| volumes.*.secret      | The secret to mount into the service container. Secrets in other projects should use the `projects/{{project}}/secrets/{{secret}}` format.                                         | string                                                                                                         |                                       | Yes      |
| volumes.*.versions    | A map of files and versions to be mounted into the path. Keys are file names to be created, and the value is the version of the secret to use (`"latest"` for the latest version). | map(string)                                                                                                    | `{ latest = "latest" }`               | No       |
| vpc_access            | Configure VPC access for this service.                                                                                                                                             | object({ connector = optional(string), egress = optional(string) })                                            | `{ connector = null, egress = null }` | No       |
| vpc_access.connector  | Name of the VPC connector to use. Connectors in other projects should use the `projects/{{projects}}/locations/${var.location}/connectors/{{connector}}` format.                   | string                                                                                                         | `null`                                | No       |
| vpc_access.egress     | Configure behaviour of egress traffic from this service. Can be one of `"all-traffic"` or `"private-ranges-only"`.                                                                 | string                                                                                                         | `"private-ranges-only"`               | No       |

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

* **2.0.0**
    * Switch to using the `google-beta` provider for Cloud Run services.
    * Bump minimum required versions: `terraform >= 0.14`, `google-beta >= 3.67.0`, `google >= 3.67.0`.
    * Add support for secrets as environment variables & volumes.
    * Add ability to configure the container's entrypoint and arguments.
    
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

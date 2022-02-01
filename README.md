Terraform Module: Google Cloud Run
==================================

A Terraform module for the [Google Cloud Platform](https://cloud.google.com) that simplifies the creation & configuration
of a Cloud Run (Fully Managed) service.

# Table of contents

* [Introduction](#introduction)
* [Requirements](#requirements)
* [Usage](#usage)
* [Secrets & Volumes](#secrets--volumes)
* [Inputs](#inputs)
  * [Required](#required-inputs)
  * [Optional](#optional-inputs)
* [Outputs](#outputs)
* [Changelog](#changelog)
* [Roadmap](#roadmap)

# Introduction

This module is wrapper around the creation & configuration of [Google Cloud Run](https://cloud.google.com/run) (Fully
managed) services, and provides sensible defaults for many of the options. 

It attempts to be as complete as possible, and expose as much functionality as is available.
As a result, some functionality might only be provided as part of BETA releases. Google's SLA support for this level of
functionality is often not as solid as with Generally-Available releases. If you require absolute stability, this module
might not be the best for you.

# Requirements

* Terraform 0.14 or higher.
* `google` provider 3.67.0 or higher.
* `google-beta` provider 3.67.0 or higher.

# Usage

```hcl-terraform
module my_cloud_run_service {
  source = "garbetjie/cloud-run/google"
  version = "~> 2"
  
  # Required parameters
  name = "my-cloud-run-service"
  image = "us-docker.pkg.dev/cloudrun/container/hello"
  location = "europe-west4"
  
  # Optional parameters
  allow_public_access = true
  args = []
  cloudsql_connections = []
  concurrency = 80
  cpu_throttling = true
  execution_environment = "gen2"
  cpus = 1
  entrypoint = []
  env = [{ key = "ENV_VAR_KEY", value = "ENV_VAR_VALUE" }]
  execution_environment = "gen1"
  ingress = "all"
  labels = {}
  map_domains = []
  max_instances = 1000
  memory = 256
  min_instances = 0
  port = 8080
  project = null
  revision = null
  service_account_email = null
  timeout = 60
  volumes = [{ path = "/mnt", secret = "my-secret", filenames = { "latest" = "latest" }}]
  vpc_access = { connector = null, egress = null }
}
```

# Secrets & Volumes

If your service requires the use of sensitive values, it is possible to store them in [Google Secret Manager](https://cloud.google.com/secret-manager)
and reference those secrets in your service. This will prevent the values of those secrets from being exposed to anyone
that might have access your service but not to the contents of the secrets.

Secrets can either be exposed as files through mounted volumes, or through environment variables. This can be configured
through the `volumes` and `env` input variables respectively.

> **Note:** Environment variables using the latest secret version will not be updated when a new version is added. Volumes
> using the latest version will have their contents automatically updated to reflect the latest secret version.

Refer to https://cloud.google.com/run/docs/configuring/secrets for further reading on secrets in Cloud Run.

# Inputs

## Required inputs

| Name     | Description                                                                          | Type   |
|----------|--------------------------------------------------------------------------------------|--------|
| name     | Name of the service.                                                                 | string |
| image    | Docker image name. Must be hosted in Google Container Registry or Artifact Registry. | string |
| location | Location of the service.                                                             | string |


## Optional inputs

| Name                  | Description                                                                                                                                                                        | Type                                                                                                           | Default                               | Required |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------------------------------|----------|
| allow_public_access   | Allow unauthenticated access to the service.                                                                                                                                       | bool                                                                                                           | `true`                                | No       |
| args                  | Arguments to pass to the entrypoint.                                                                                                                                               | list(string)                                                                                                   | `[]`                                  | No       |
| cloudsql_connections  | Cloud SQL connections to attach to container instances.                                                                                                                            | set(string)                                                                                                    | `[]`                                  | No       |
| concurrency           | Maximum allowed concurrent requests per container for this revision.                                                                                                               | number                                                                                                         | `null`                                | No       |
| cpu_throttling        | Configure CPU throttling outside of request processing.                                                                                                                            | bool                                                                                                           | `true`                                | No       |
| cpus                  | Number of CPUs to allocate per container.                                                                                                                                          | number                                                                                                         | `1`                                   | No       |
| entrypoint            | Entrypoint command. Defaults to the image's ENTRYPOINT if not provided.                                                                                                            | list(string)                                                                                                   | `[]`                                  | No       |
| env                   | Environment variables to inject into container instances. Exactly one of `value` or `secret` must be specified.                                                                    | set(object({ key = string, value = optional(string), secret = optional(string), version = optional(string) })) | `[]`                                  | No       |
| env.*.key             | Name of the environment variable.                                                                                                                                                  | string                                                                                                         |                                       | Yes      |
| env.*.value           | Raw string value of the environment variable.                                                                                                                                      | optional(string)                                                                                               | `null`                                | No       |
| env.*.secret          | Secret to populate the environment variable from. Secrets in other projects should use the `projects/{{project}}/secrets/{{secret}}` format.                                       | optional(string)                                                                                               | `null`                                | No       |
| env.*.version         | Version to use when populating with a secret. Defaults to the latest version.                                                                                                      | string                                                                                                         | `"latest"`                            | No       |
| execution_environment | Execution environment to run under. Allowed values: [`"gen1"`, `"gen2"`]                                                                                                           | string                                                                                                         | `"gen1"`                              | No       |
| http2                 | Enable use of HTTP/2 end-to-end.                                                                                                                                                   | bool                                                                                                           | `false`                               | No       |
| ingress               | Ingress settings for the service. Allowed values: [`"all"`, `"internal"`, `"internal-and-cloud-load-balancing"`]                                                                   | string                                                                                                         | `all`                                 | No       |
| labels                | [Labels](https://cloud.google.com/run/docs/configuring/labels) to apply to the service.                                                                                            | map(string)                                                                                                    | `{}`                                  | No       |
| map_domains           | Domain names to map to the service.                                                                                                                                                | set(string)                                                                                                    | `[]`                                  | No       |
| max_instances         | Maximum number of container instances allowed to start.                                                                                                                            | number                                                                                                         | `1000`                                | No       |
| memory                | Memory (in Mi) to allocate to containers. If `execution_environment` is `"gen2"`, this needs to be >= 512.                                                                         | number                                                                                                         | `256`                                 | No       |
| min_instances         | Minimum number of container instances to keep running.                                                                                                                             | number                                                                                                         | `0`                                   | No       |
| port                  | Port on which the container is listening for incoming HTTP requests.                                                                                                               | number                                                                                                         | `8080`                                | No       |
| project               | Google Cloud project in which to create resources.                                                                                                                                 | string                                                                                                         | `null`                                | No       |
| revision              | Revision name to use. When `null`, revision names are automatically generated.                                                                                                     | string                                                                                                         | `null`                                | No       |
| service_account_email | IAM service account email to assign to container instances.                                                                                                                        | string                                                                                                         | `null`                                | No       |
| timeout               | Maximum duration (in seconds) allowed for responding to requests.                                                                                                                  | number                                                                                                         | `60`                                  | No       |
| volumes               | Volumes to be mounted & populated from secrets.                                                                                                                                    | set(object({ path = string, secret = string, versions = optional(map(string)) }))                              | `[]`                                  | No       |
| volumes.*.path        | Path into which the secret will be mounted. The same path cannot be specified for multiple volumes.                                                                                | string                                                                                                         |                                       | Yes      |
| volumes.*.secret      | The secret to mount into the service container. Secrets in other projects should use the `projects/{{project}}/secrets/{{secret}}` format.                                         | string                                                                                                         |                                       | Yes      |
| volumes.*.versions    | A map of files and versions to be mounted into the path. Keys are file names to be created, and the value is the version of the secret to use (`"latest"` for the latest version). | map(string)                                                                                                    | `{ latest = "latest" }`               | No       |
| vpc_access            | Control VPC access for the service.                                                                                                                                                | object({ connector = optional(string), egress = optional(string) })                                            | `{ connector = null, egress = null }` | No       |
| vpc_access.connector  | Name of the VPC connector to use. Connectors in other projects should use the `projects/{{projects}}/locations/${var.location}/connectors/{{connector}}` format.                   | string                                                                                                         | `null`                                | No       |
| vpc_access.egress     | Configure behaviour of egress traffic from this service. Can be one of `"all-traffic"` or `"private-ranges-only"`.                                                                 | string                                                                                                         | `"private-ranges-only"`               | No       |

# Outputs

In addition to the inputs documented above, the following values are available as outputs:

| Name                         | Description                                                                                                | Type                                                                                                |
|------------------------------|------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------|
| latest_ready_revision_name   | Latest revision ready for use.                                                                             | string                                                                                              |
| latest_created_revision_name | Last revision created.                                                                                     | string                                                                                              |
| url                          | URL at which the service is available.                                                                     | string                                                                                              |
| id                           | ID of the created service.                                                                                 | string                                                                                              |
| dns                          | DNS records to populate for mapped domains. Keys are the domains that were specified in `var.map_domains`. | map(list(object({ name = optional(string), root = string, type = string, rrdatas = set(string) }))) |

# Changelog

* **2.2.0**
    * Implement [execution environment](https://cloud.google.com/run/docs/configuring/execution-environments) configuration (thanks @dennislapchenko).

* **2.1.1**
    * Placed `run.googleapis.com/launch-stage` in the service's annotations, not the revision's. 

* **2.1.0**
    * Implement CPU throttling configuration (thanks @salimkayabasi).
    * Implement HTTP/2 end-to-end support.

* **2.0.0**
    * Switch to using the `google-beta` provider for Cloud Run services.
    * Bump minimum required versions: `terraform >= 0.14`, `google-beta >= 3.67.0`, `google >= 3.67.0`.
    * Add support for secrets as environment variables & volumes.
    * Add ability to configure the container's entrypoint and arguments.
    * Add inputs as outputs.
    
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

# Roadmap

Issues containing possible future enhancements can be found [here](https://github.com/garbetjie/terraform-google-cloud-run/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement).

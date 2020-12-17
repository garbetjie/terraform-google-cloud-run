output name {
  value = google_cloud_run_service.default.name
  description = "Name of the created service."
}

output revision {
  value = google_cloud_run_service.default.status[0].latest_ready_revision_name
  description = "Deployed revision for the service."
}

output url {
  value = google_cloud_run_service.default.status[0].url
  description = "The URL on which the deployed service is available."
}

locals {
  output_dns_pairs = {
    for domain in var.map_domains:
      domain => distinct([
        for record in google_cloud_run_domain_mapping.domains[domain].status[0].resource_records:
          "${record.type}/${record.name}"
      ])
  }
  output_dns_rrdata_by_pairs = {
    for domain in var.map_domains:
      domain => {
        for pair in local.output_dns_pairs[domain]:
          pair => [
            for record in google_cloud_run_domain_mapping.domains[domain].status[0].resource_records:
              record.rrdata
            if "${record.type}/${record.name}" == pair
          ]
      }
  }
}

output dns {
  value = {
    for domain in var.map_domains:
      domain => [
        for pair, rrdatas in local.output_dns_rrdata_by_pairs[domain]: {
          type = split("/", pair)[0],
          name = split("/", pair)[1] == "" ? null : split("/", pair)[1],
          rrdatas = rrdatas
        }
      ]
  }
  description = "DNS records to populate for mapped domains. Keys are the domains that are mapped."
}

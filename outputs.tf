output name {
  value = google_cloud_run_service.default.name
}

output revision {
  value = google_cloud_run_service.default.status[0].latest_ready_revision_name
}

output url {
  value = google_cloud_run_service.default.status[0].url
}

output dns {
  value =  {
    for index, value in var.map_domains:
      value => google_cloud_run_domain_mapping.domains[value].status[0].resource_records
  }
}

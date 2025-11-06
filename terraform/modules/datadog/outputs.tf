output "monitor_ids" {
  description = "IDs of created monitors"
  value = {
    high_cpu          = datadog_monitor.high_cpu.id
    high_memory       = datadog_monitor.high_memory.id
    high_disk         = datadog_monitor.high_disk.id
    apache_down       = datadog_monitor.apache_down.id
    host_unreachable  = datadog_monitor.host_unreachable.id
    http_errors       = datadog_monitor.http_errors.id
    request_anomaly   = datadog_monitor.request_anomaly.id
    host_critical     = datadog_monitor.host_critical.id
  }
}

output "dashboard_url" {
  description = "URL of the infrastructure dashboard"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.infrastructure.id}"
}

output "slo_id" {
  description = "ID of the availability SLO"
  value       = datadog_service_level_objective.availability.id
}

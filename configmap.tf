resource "kubernetes_config_map" "grafana-agent" {
  metadata {
    name      = local.app_name
    labels    = local.commonLabels
    namespace = data.kubernetes_namespace.ns.metadata.0.name
  }

  data = {
    "agent.yml" = templatefile("${path.module}/agent.yml", {
      TEMPO_USERNAME = var.tempo_username
      TEMPO_ENDPOINT = var.tempo_endpoint
      TEMPO_ATTRIBUTES                = var.tempo_attributes
      TEMPO_ENDPOINT_RETRY_ON_FAILURE = var.tempo_endpoint_retry_on_failure
      TEMPO_ENDPOINT_HEADERS          = var.tempo_endpoint_headers
      TEMPO_ENDPOINT_PROTOCOL         = var.tempo_endpoint_protocol
      TEMPO_ADDITIONAL_ENDPOINTS      = var.tempo_additional_endpoints
    })
    "strategies.json" = "{\"default_strategy\": {\"param\": 0.001, \"type\": \"probabilistic\"}}"
  }
} 
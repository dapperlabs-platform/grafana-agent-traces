resource "kubernetes_service_account" "grafana-agent" {
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.commonLabels
  }
}
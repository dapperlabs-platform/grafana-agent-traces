resource "kubernetes_service" "grafana-agent" {
  metadata {
    name      = local.app_name
    labels    = local.commonLabels
    namespace = data.kubernetes_namespace.ns.metadata.0.name
  }

  spec {
    selector = local.selectorLabels

    port {
      name        = "agent-http-metrics"
      port        = 8080
      target_port = 8080
    }

    port {
      name        = "jaeger-grpc"
      port        = 14250
      target_port = 14250
      protocol    = "TCP"
    }

  }
}

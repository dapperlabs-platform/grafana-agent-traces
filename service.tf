resource "kubernetes_service" "agent" {
  metadata {
    name      = var.name
    labels    = local.labels
    namespace = var.namespace
  }

  spec {
    selector = local.labels

    dynamic "port" {
      for_each = local.ports
      content {
        name        = port.key
        port        = port.value
        target_port = port.value
      }
    }
  }
}

resource "kubernetes_config_map" "tempo" {
  metadata {
    name      = local.app_name
    labels    = local.commonLabels
    namespace = data.kubernetes_namespace.ns.metadata.0.name
  }

  data = {
    "agent.yml" = "${file("${path.module}/files/agent.yml")}"
  }
} 
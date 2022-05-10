resource "kubernetes_cluster_role_binding" "grafana-agent" {
  metadata {
    name   = local.app_name
    labels = local.commonLabels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.grafana-agent.id
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.grafana-agent.metadata.0.name
    namespace = kubernetes_service_account.grafana-agent.metadata.0.namespace
  }
}

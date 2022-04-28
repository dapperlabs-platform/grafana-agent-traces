resource "kubernetes_cluster_role_binding" "tempo" {
  metadata {
    name   = local.app_name
    labels = local.commonLabels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tempo.id
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tempo.metadata.0.name
    namespace = kubernetes_service_account.tempo.metadata.0.namespace
  }
}

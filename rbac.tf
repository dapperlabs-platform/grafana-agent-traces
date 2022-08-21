resource "kubernetes_manifest" "service_account" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    # https://github.com/hashicorp/terraform-provider-kubernetes/issues/1724#issuecomment-1141860219
    automountServiceAccountToken = true
  }
}

resource "kubernetes_cluster_role_v1" "agent" {
  metadata {
    name   = var.name
    labels = local.labels
  }
  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "agent" {
  metadata {
    name   = var.name
    labels = local.labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.agent.id
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
  }
}

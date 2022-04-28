resource "kubernetes_cluster_role" "tempo" {
  metadata {
    name   = local.app_name
    labels = local.commonLabels
  }

  rules {
    api_groups        = [""]
    resources         = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
    verbs             = ["get", "list", "watch"]
    non_resource_urls = ["/metrics"]
  }
}
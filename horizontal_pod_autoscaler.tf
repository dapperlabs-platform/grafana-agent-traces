resource "kubernetes_horizontal_pod_autoscaler" "hpa" {
  count = var.horizontal_pod_autoscaler == null ? 0 : 1
  metadata {
    name      = local.app_name
    namespace = data.kubernetes_namespace.ns.metadata.0.name
    labels    = local.commonLabels
  }

  spec {
    max_replicas = var.replicas.max
    min_replicas = var.replicas.min

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = local.app_name
    }

    behavior {
      scale_down {
        select_policy = "Max"
        # Wait for 5 min before scaling down
        stabilization_window_seconds = 300

        # Remove 10% of pods per minute
        policy {
          period_seconds = 60
          type           = "Percent"
          value          = 10
        }
      }

      scale_up {
        select_policy = "Max"
        # Wait for 1 min before scaling further up
        stabilization_window_seconds = 60

        # If threshold is breached for 1 min, scale up by 3 pods
        policy {
          period_seconds = 60
          type           = "Pods"
          value          = 3
        }
      }
    }

    dynamic "metric" {
      for_each = var.horizontal_pod_autoscaler.resource_metrics
      content {
        type = "Resource"
        resource {
          name = metric.value.name
          target {
            type                = metric.value.type
            average_utilization = metric.value.average_utilization
          }
        }
      }
    }
  }
}
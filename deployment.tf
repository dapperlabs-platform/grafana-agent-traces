resource "kubernetes_deployment_v1" "agent" {
  depends_on = [kubernetes_manifest.agent]
  metadata {
    name      = var.name
    labels    = local.labels
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = local.labels
    }
    replicas = var.deployment_replica_count

    template {
      metadata {
        labels = local.labels
      }

      spec {
        service_account_name             = var.name
        termination_grace_period_seconds = 300
        node_selector                    = var.deployment_node_selector
        priority_class_name              = try(var.priority_class_name, null)

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              pod_affinity_term {
                topology_key = "topology.kubernetes.io/zone"
                label_selector {
                  match_labels = local.labels
                }
              }
            }
          }
        }

        toleration {
          effect   = "NoSchedule"
          operator = "Exists"
        }

        container {
          image             = "${var.grafana_agent_image.base}:${var.grafana_agent_image.version}"
          name              = var.name
          image_pull_policy = "IfNotPresent"
          command           = ["/bin/agent"]

          args = [
            "-config.file=/etc/agent/agent.yaml",
            "-config.expand-env",
          ]

          dynamic "env" {
            for_each = var.deployment_env
            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = var.deployment_env_from_field_ref
            content {
              name = env.value.name
              value_from {
                field_ref {
                  field_path = env.value.field_path
                }
              }
            }
          }

          dynamic "port" {
            for_each = local.ports
            content {
              name           = port.key
              container_port = port.value
              protocol       = "TCP"
            }
          }

          resources {
            limits   = var.deployment_resources.limits
            requests = var.deployment_resources.requests
          }

          volume_mount {
            mount_path = "/etc/agent"
            name       = "agent-config"
          }

          volume_mount {
            mount_path = "/run/secrets/grafana"
            name       = "tempo-api-key"
          }
        }

        volume {
          name = "agent-config"
          config_map {
            name     = var.name
            optional = false
          }
        }

        volume {
          name = "tempo-api-key"
          secret {
            default_mode = "0420"
            secret_name  = var.tempo_api_key_secret.name
            optional     = false
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "tempo" {
  metadata {
    name      = local.app_name
    labels    = local.commonLabels
    namespace = data.kubernetes_namespace.ns.metadata.0.name
  }

  spec {
    replicas               = var.replicas.min
    min_ready_seconds      = var.min_ready_seconds
    revision_history_limit = var.revision_history_limit

    selector {
      match_labels = local.selectorLabels
    }

    template {
      metadata {
        labels = local.selectorLabels
      }
    }

    spec {
      service_account_name             = kubernetes_service_account.tempo.metadata.0.name
      termination_grace_period_seconds = 300
      node_selector                    = var.deployment_node_selector

      container {
        image = "${var.grafana_tempo_image.base}:${var.grafana_tempo_image.version}"
        name = "agent"
        image_pull_policy = "IfNotPresent"
        lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
        }
        args = ["-config.file=/etc/agent/agent.yml"]
        env {
            name = "HOSTNAME"
            value_from {
                field_ref {
                    field_path = "spec.nodeName"
                }
            }
        }
        port {
            name           = "http-metrics"
            container_port = 8080
        }
        port {
            name           = "thrift-compact"
            container_port = 6831
            protocol = UDP
        }
        port {
            name           = "thrift-binary"
            container_port = 6832
            protocol = UDP
        }
        port {
            name           = "thrift-http"
            container_port = 14268
            protocol = TCP
        }
        port {
            name           = "thrift-grpc"
            container_port = 14250
            protocol = TCP
        }
        port {
            name           = "zipkin"
            container_port = 9411
            protocol = TCP
        }
        port {
            name           = "otlp"
            container_port = 55680
            protocol = TCP
        }
        port {
            name           = "otlp-http"
            container_port = 4318
            protocol = TCP
        }
        port {
            name           = "opencensus"
            container_port = 55678
            protocol = TCP
        }
        port {
            name           = "span-metrics"
            container_port = 8889
            protocol = TCP
        }
        resources {
            limits = {
                cpu = var.grafana_tempo_resources.limits.cpu
                memory = var.grafana_tempo_resources.limits.memory
            }
            requests = {
                cpu = var.grafana_tempo_resources.requests.cpu
                memory = var.grafana_tempo_resources.requests.memory
            }
        }
        liveness_probe {
            http_get {
                path = "/healthz"
                port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
            failure_threshold     = 5
        }
        readiness_probe {
            http_get {
              path = "/healthz"
              port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1
            failure_threshold     = 5
        }
        volume_mount {
            mount_path = "/etc/agent"
            name       = "grafana-agent-traces"
        }
    
    }

    volume {
        name = "grafana-agent-traces"
        config_map {
            name = "grafana-agent-traces"
        }
    }
  } 
}

locals {
  k8s_service_discovery_additional_relabel_configs = [
    { target_label : "project", "replacement" : var.project },
    { target_label : "env", "replacement" : var.environment },
  ]
}
resource "kubernetes_manifest" "agent" {
  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    data = {
      "agent.yaml" = yamlencode({
        server = {
          log_level  = var.tempo_server_log_level
          log_format = var.tempo_server_log_format
        }
        traces = {
          configs = [{
            name = "default"
            scrape_configs = [{
              bearer_token_file = "/var/run/secrets/kubernetes.io/serviceaccount/token",
              job_name          = "kubernetes-pods",
              kubernetes_sd_configs : [{ role : "pod" }],
              relabel_configs : concat([
                { source_labels : ["__meta_kubernetes_namespace"], target_label : "namespace" },
                { source_labels : ["__meta_kubernetes_pod_label_app"], target_label : "app" },
                { source_labels : ["__meta_kubernetes_pod_name"], target_label : "pod" },
                { source_labels : ["__meta_kubernetes_pod_container_name"], target_label : "container" },
              ], local.k8s_service_discovery_additional_relabel_configs)
              tls_config : {
                ca_file : "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
                insecure_skip_verify : false
              }
            }]
            batch = {
              send_batch_size = var.tempo_batch_send_batch_size
              timeout         = var.tempo_batch_timeout
            }
            remote_write = concat([{
              endpoint = var.tempo_endpoint
              basic_auth = {
                username = var.tempo_username
                password_file : "/run/secrets/grafana/${var.tempo_api_key_secret.key}"
              }
              retry_on_failure = {
                enabled : true
              }
            }], var.additional_remote_writes)
            receivers = {
              otlp = {
                protocols = {
                  grpc = {
                    include_metadata : true
                  }
                }
              }
            }
            automatic_logging = {
              backend = "stdout"
              roots : true
              overrides = {
                trace_id_key : "trace_id"
              }
            }
          }]
        }
      })
    }
  }
}

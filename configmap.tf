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
            attributes = {
              actions = [{
                key    = "env"
                action = "upsert"
                value  = var.environment
                }, {
                key    = "project"
                action = "upsert"
                value  = var.project
              }]
            }
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

locals {
  app_name = "grafana-agent"
  labels = {
    "app.kubernetes.io/app"        = var.name
    "app.kubernetes.io/managed-by" = "Terraform"
  }
  ports = {
    "http-metrics" = 8080
    "otel-grpc"    = 4317
  }
}

output "otlp_grpc_endpoint" {
  description = "Cluster-local otlp-gRPC collector endpoint"
  value       = "${var.name}.${var.namespace}.svc.cluster.local:4317"
}

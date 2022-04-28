resource "kubernetes_service" "tempo" {
  metadata {
    name      = local.app_name
    labels    = local.commonLabels
    namespace = data.kubernetes_namespace.ns.metadata.0.name
  }

  spec {
    selector = local.selectorLabels

    port {
      name        = "agent-http-metrics"
      port        = 8080
      target_port = 8080
    }

    port {
      name        = "jaeger-thrift-compact"
      port        = 6831
      target_port = 6831
      protocol    = UDP
    }

    port {
      name        = "jaeger-thrift-binary"
      port        = 6832
      target_port = 6832
      protocol    = UDP
    }

    port {
      name        = "jaeger-thrift-http"
      port        = 14268
      target_port = 14268
      protocol    = TCP
    }

    port {
      name        = "jaeger-grpc"
      port        = 14250
      target_port = 14250
      protocol    = TCP
    }

    port {
      name        = "zipkin"
      port        = 9411
      target_port = 9411
      protocol    = TCP
    }

    port {
      name        = "otlp"
      port        = 55680
      target_port = 55680
      protocol    = TCP
    }

    port {
      name        = "opencensus"
      port        = 55678
      target_port = 55678
      protocol    = TCP
    }


  }
}

variable "namespace" {
  description = "Deployment namespace"
  type        = string
}

variable "tempo_endpoint" {
  description = "Tempo Endpoint"
  type        = string
}

variable "tempo_endpoint_headers" {
  description = "Additional headers to send for default endpoint"
  type        = map(any)
  default = false
}

variable "tempo_endpoint_retry_on_failure" {
  description = "Retry on Failure"
  type        = bool
  default = false
}

variable "tempo_endpoint_protocol" {
  description = "Protocol to use when sending requests to the forst endpoint"
  type        = string
  default = "grpc"
}

variable "tempo_username" {
  description = "Tempo username"
  type        = string
}

variable "tempo_password" {
  description = "Tempo password"
  type        = string
}

variable "tempo_additional_endpoints" {
  description = "Tempo additional endpoints"
  type        = list(any)
  default = []
}

variable "tempo_attributes" {
  type        = map(any)
  default     = {}
  description = "Attributes to set for endpoints."
}

variable "replicas" {
  description = "Number of deployment replicas"
  type = object({
    max = number
    min = number
  })
  default = {
    max = 24
    min = 3
  }
}

variable "prometheus_scrape" {
  description = "Enable prometheus scraping"
  type        = bool
  default     = true
}

variable "enable-agent-http-metrics" {
  description = "Enable Agent http metrics service"
  type        = bool
  default     = false
}

variable "http-agent-metrics" {
  description = "Agent http metrics port"
  type = object({
    port = object({
      name        = string
      port        = number
      target_port = number
    })
  })
  default = {
    port = {
      name        = "agent-http-metrics"
      port        = 8080
      target_port = 8080
    }
  }
}

variable "enable-jaeger-grpc" {
  description = "Enable Jaeger grpc metrics service"
  type        = bool
  default     = false
}

variable "jaeger-grpc" {
  description = "jaeger-grpc  metrics port"
  type = object({
    port = object({
      name        = string
      port        = number
      target_port = number
      protocol    = string
    })
  })
  default = {
    port = {
      name        = "agent-http-metrics"
      port        = 8080
      target_port = 8080
      protocol    = TCP
    }
  }
}

variable "grafana-agent-image" {
  description = "Grafana agent container image"
  type = object({
    base    = string
    version = string
  })
  default = {
    base    = "grafana/agent"
    version = "v0.21.1"
  }
}

variable "grafana-agent-resources" {
  description = "Grafana agent container resource configuration"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "2"
      memory = "1G"
    }
    requests = {
      cpu    = "1"
      memory = "512M"
    }
  }
}
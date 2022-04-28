variable "namespace" {
  description = "Deployment namespace"
  type        = string
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

variable "grafana_tempo_image" {
  description = "Grafana Tempo container image"
  type = object({
    base    = string
    version = string
  })
  default = {
    base    = "grafana/agent"
    version = "v0.21.1"
  }
}

variable "grafana_tempo_resources" {
  description = "Grafana Tempo container resource configuration"
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
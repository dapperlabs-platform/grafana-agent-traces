variable "additional_remote_writes" {
  description = "Additional trace backend remote_write configs"
  type        = list(any)
  default     = []
}

variable "deployment_node_selector" {
  description = "Map of label names and values to assign the podspec's nodeSelector property"
  type        = map(string)
  default = {
    # "ops.dapperlabs.com/preferred-namespace" = "sre"
  }
}

variable "deployment_replica_count" {
  description = "Number of replicas for the agent deployment"
  type        = number
  default     = 5
}

variable "deployment_resources" {
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

variable "deployment_env" {
  description = "Add environment variables from key/value pairs"
  type        = map(string)
  default     = {}
}

variable "deployment_env_from_field_ref" {
  description = "Add environment variables from fieldRef"
  type = list(object({
    name       = string
    field_path = string
  }))
  default = []
}

variable "environment" {
  description = "Value of the `env` resource tag, e.g. development, staging or production"
  type        = string
}

variable "grafana_agent_image" {
  description = "Grafana agent container image"
  type = object({
    base    = string
    version = string
  })
  default = {
    base    = "grafana/agent"
    version = "v0.28.0"
  }
}

variable "name" {
  description = "Deployment and service name"
  type        = string
  default     = "grafana-tracing-agent"
}

variable "namespace" {
  description = "Deployment namespace"
  type        = string
}

variable "project" {
  description = "Value of the `project` span tag"
  type        = string
}

variable "priority_class_name" {
  description = "Agent deployment priorityClassName"
  type        = string
  default     = null
}

variable "tempo_api_key_secret" {
  description = "K8S secret for the Metrics Writer Grafana Cloud API Key"
  type = object({
    name = string
    key  = string
  })
}

variable "tempo_endpoint" {
  description = "Tempo Endpoint"
  type        = string
}

variable "tempo_username" {
  description = "Tempo username"
  type        = string
}

variable "tempo_batch_send_batch_size" {
  description = "Agent config send batch size"
  type        = number
  default     = 1000
}

variable "tempo_batch_timeout" {
  description = "Agent config batch send timeout"
  type        = string
  default     = "5s"
}

variable "tempo_server_log_level" {
  description = "Agent config log level"
  type        = string
  default     = "info"
}

variable "tempo_server_log_format" {
  description = "Agent config log format"
  type        = string
  default     = "json"
}

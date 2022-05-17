terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3.2"
    }
  }
}

data "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

locals {
  app_name = "grafana-agent-traces"
  commonLabels = {
    "app.kubernetes.io/app"        = local.app_name
    "app.kubernetes.io/owner"      = "sre"
    "app.kubernetes.io/managed-by" = "Terraform"
  }
  selectorLabels = {
    "app.kubernetes.io/app" = local.app_name
  }
}

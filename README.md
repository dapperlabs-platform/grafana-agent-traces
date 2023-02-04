# Grafana Agent Traces

https://github.com/grafana/agent#getting-started

## What does this do?

This module provisions a Grafana Agent K8S deployment with opinionanted configurations.

## How to use it

```hcl
module "agent" {
  source         = "github.com/dapperlabs-platform/terraform-grafana-agent-traces?ref=<latest-tag>"
  namespace      = "sre"
  project        = "deathstar"
  environment    = "production"
  tempo_username = "112233"
  tempo_endpoint = "http://tempo-us-central1.grafana.net:443"
  tempo_api_key_secret = {
    name = "tempo-api-key-secret"
    key  = "key"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding.agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_v1.agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_deployment_v1.agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_manifest.agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_service.agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_remote_writes"></a> [additional\_remote\_writes](#input\_additional\_remote\_writes) | Additional trace backend remote\_write configs | `list(any)` | `[]` | no |
| <a name="input_deployment_env"></a> [deployment\_env](#input\_deployment\_env) | Add environment variables from key/value pairs | `map(string)` | `{}` | no |
| <a name="input_deployment_env_from_field_ref"></a> [deployment\_env\_from\_field\_ref](#input\_deployment\_env\_from\_field\_ref) | Add environment variables from fieldRef | <pre>list(object({<br>    name       = string<br>    field_path = string<br>  }))</pre> | `[]` | no |
| <a name="input_deployment_node_selector"></a> [deployment\_node\_selector](#input\_deployment\_node\_selector) | Map of label names and values to assign the podspec's nodeSelector property | `map(string)` | `{}` | no |
| <a name="input_deployment_replica_count"></a> [deployment\_replica\_count](#input\_deployment\_replica\_count) | Number of replicas for the agent deployment | `number` | `5` | no |
| <a name="input_deployment_resources"></a> [deployment\_resources](#input\_deployment\_resources) | Grafana agent container resource configuration | <pre>object({<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "limits": {<br>    "cpu": "2",<br>    "memory": "1G"<br>  },<br>  "requests": {<br>    "cpu": "1",<br>    "memory": "512M"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Value of the `env` span tag, e.g. development, staging or production | `string` | n/a | yes |
| <a name="input_grafana_agent_image"></a> [grafana\_agent\_image](#input\_grafana\_agent\_image) | Grafana agent container image | <pre>object({<br>    base    = string<br>    version = string<br>  })</pre> | <pre>{<br>  "base": "grafana/agent",<br>  "version": "v0.24.1"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Deployment and service name | `string` | `"grafana-tracing-agent"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Deployment namespace | `string` | n/a | yes |
| <a name="input_priority_class_name"></a> [priority\_class\_name](#input\_priority\_class\_name) | Agent deployment priorityClassName | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Value of the `project` span tag | `string` | n/a | yes |
| <a name="input_tempo_api_key_secret"></a> [tempo\_api\_key\_secret](#input\_tempo\_api\_key\_secret) | K8S secret for the Metrics Writer Grafana Cloud API Key | <pre>object({<br>    name = string<br>    key  = string<br>  })</pre> | n/a | yes |
| <a name="input_tempo_endpoint"></a> [tempo\_endpoint](#input\_tempo\_endpoint) | Tempo Endpoint | `string` | n/a | yes |
| <a name="input_tempo_username"></a> [tempo\_username](#input\_tempo\_username) | Tempo username | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otlp_grpc_endpoint"></a> [otlp\_grpc\_endpoint](#output\_otlp\_grpc\_endpoint) | Cluster-local otlp-gRPC collector endpoint |

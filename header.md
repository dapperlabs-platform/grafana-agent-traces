# Grafana Agent Traces

https://github.com/grafana/agent#getting-started

## What does this do?

This module provisions a Grafana Agent K8S deployment with opinionanted configurations.

## How to use it

```hcl
module "agent" {
  source         = "github.com/dapperlabs-platform/grafana-agent-traces?ref=<latest-tag>"
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

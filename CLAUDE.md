# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository demonstrates best practices for deploying Honeycomb Refinery clusters on Kubernetes (AWS EKS) using Helm, along with OpenTelemetry collectors for monitoring and Terraform for managing Honeycomb triggers/alerts. It is designed for field engineering teams running Refinery-as-a-Service (RaaS) test environments in both US and EU regions.

## IMPORTANT: Do Not Run Commands Directly

**NEVER run the following commands directly:**

- `helm` commands (e.g., `helm upgrade`, `helm install`)
- `terraform` commands (e.g., `terraform apply`, `terraform plan`)
- `kubectl` commands (e.g., `kubectl apply`, `kubectl create`)

All deployments and infrastructure changes are managed through GitHub Actions workflows. If the user asks you to deploy or make changes:

1. Help them edit the relevant configuration files (values YAML files, Terraform files)
2. Commit and push changes to the `main` branch
3. Let GitHub Actions handle the deployment

The only exception is if the user explicitly asks you to run commands locally for testing or debugging purposes.

## Architecture

### Components

1. **Refinery Deployment** (`refinery-values.yaml`)

   - Helm values for deploying Refinery to AWS EKS clusters
   - Configures AWS Load Balancer Controller and External DNS Controller via Ingress annotations
   - Includes sampling rules configuration for trace management
   - Currently set up for m7g.large instances (2 vCPU, 8 GiB memory) with commented examples for r7g.4xlarge

2. **Kubernetes Monitoring**

   - `k8sevents-values.yaml`: OpenTelemetry collector for Kubernetes Events API monitoring
   - `kubeletstats-values.yaml`: OpenTelemetry collector for kubelet metrics (pods, containers, nodes)
   - Both collectors are scoped to specific namespaces/nodegroups and send data to Honeycomb

3. **Honeycomb Triggers** (`terraform/`)
   - Terraform manages Honeycomb triggers for Refinery health monitoring
   - Uses the `honeycombio` provider (v0.23.0)
   - Stores state in Kubernetes backend (configured via `~/.kubeconfig`)
   - Triggers monitor: dropped incoming events, stress relief activation, dropped peer events, and incoming traffic health

### Multi-Region Support

The repository supports both US (us-east-1) and EU (eu-west-1) deployments. GitHub Actions workflows automatically select the correct secrets and configurations based on the `AWS_REGION` variable.

## Common Commands

**Note:** These commands are provided for reference and documentation purposes only. Do not run them directly - they are executed by GitHub Actions workflows.

### Helm Deployments

**Deploy Refinery:**

```bash
NAMESPACE='your-namespace'
helm repo add honeycomb https://honeycombio.github.io/helm-charts
helm repo update
helm upgrade -n ${NAMESPACE} --install refinery honeycomb/refinery -f refinery-values.yaml --wait
```

**Deploy Kubernetes Monitoring:**

```bash
NAMESPACE='your-namespace'
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update
helm upgrade -n ${NAMESPACE} --install otelcol-kubeletstats open-telemetry/opentelemetry-collector -f kubeletstats-values.yaml --wait
helm upgrade -n ${NAMESPACE} --install otelcol-k8sevents open-telemetry/opentelemetry-collector -f k8sevents-values.yaml --wait
```

### Terraform Operations

**Working directory:** `terraform/`

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

**Required environment variables:**

- `HONEYCOMB_API_KEY`: Configuration API key for Honeycomb
- `HONEYCOMB_API_ENDPOINT`: Either `https://api.honeycomb.io` or `https://api.eu1.honeycomb.io`
- `KUBE_NAMESPACE`: Kubernetes namespace for state backend

**Terraform Variables:**

- `refinery_metrics_dataset`: Dataset name (default: "refinery-otel-metrics")
- `slack_recipient_channel`: Slack channel for alerts (default: "#collab-hosted-refinery-for-pocs")
- `create_slack_recipient`: Whether to create Slack recipient (default: false)

### Create Kubernetes Secrets

Refinery and collectors require secrets for Honeycomb API keys:

```bash
kubectl create secret generic raas-secrets \
  --from-literal=refinery-metrics-api-key=<YOUR_HONEYCOMB_API_KEY> \
  --from-literal=refinery-query-auth-token=<YOUR_AUTH_TOKEN> \
  -n <NAMESPACE> \
  --dry-run=client -o yaml | kubectl apply -f -
```

## GitHub Actions Workflows

All workflows skip the first run (when creating from template) via `if: github.run_number != 1`.

### `.github/workflows/refinery-deploy.yaml`

- Triggers: Manual dispatch or push to `main` (when `refinery-values.yaml` or the workflow file changes)
- Deploys Refinery to EKS using region-specific secrets (US or EU)
- Automatically configures Ingress with ACM certificates and DNS names from secrets
- Sets Honeycomb API endpoints based on region

### `.github/workflows/k8s-monitoring-deploy.yaml`

- Deploys OpenTelemetry collectors for Kubernetes monitoring
- Region-aware (US/EU)

### `.github/workflows/tf-hny-triggers.yaml`

- Triggers: Manual dispatch or push to `main` (when `terraform/**.tf` changes)
- Runs Terraform to create/update Honeycomb triggers
- Uses Kubernetes backend for state storage

## Key Configuration Points

### Refinery Values (`refinery-values.yaml`)

- **Ingress annotations**: AWS-specific (ALB Controller, External DNS) - modify for other K8s providers
- **nodeSelector**: Set to `customer: hnytest` - update for your environment or remove if not using dedicated nodes
- **Sampling rules**: Configured in `rules` section - keep errors/slow requests, drop healthchecks, dynamically sample normal traffic
- **Resource sizing**: Customizable via YAML anchors at top of file (`&memory`, `&cpu`, queue sizes, etc.)

### Monitoring Values

- **k8sevents-values.yaml**: Update `namespaces` array in `k8sobjects.objects[0]` to match your deployment namespace
- **kubeletstats-values.yaml**: Update `nodeSelector` to match your Refinery nodes

### Terraform

- **columns.tf**: Pre-creates Honeycomb columns via API call before creating triggers (ensures columns exist)
- **trigger.tf**: Defines 4 triggers for Refinery health monitoring
- **recipients.tf**: Searches for Slack recipient (unused but present)

## Required GitHub Secrets and Variables

See `variables.md` for complete documentation.

**Variables:**

- `AWS_REGION`: us-east-1 or eu-west-1
- `CLUSTER_NAME`: EKS cluster name
- `HONEYCOMB_API_ENDPOINT`: Region-specific API endpoint
- `K8S_NAMESPACE`: Target namespace

**Secrets (region-specific):**

- `AWS_GH_EKS_ROLE` / `AWS_GH_EKS_ROLE_EU`: IAM role for EKS access
- `ACM_ARN` / `ACM_ARN_EU`: AWS Certificate Manager ARN
- `DNS_NAME` / `DNS_NAME_EU`: Route53 DNS name
- `REFINERY_HONEYCOMB_API_KEY`: Honeycomb API key with trigger creation permissions
- `REFINERY_QUERY_AUTH_TOKEN`: Auth token for Refinery endpoint
- `SLACK_RECIPIENT_CHANNEL`: Slack channel for alerts

## Important Notes

- This repo is designed for dedicated node deployments - monitoring collectors are scoped to specific nodegroups to avoid duplicate metrics
- The Ingress configuration is AWS-specific; other cloud providers will need different annotations
- Terraform state is stored in Kubernetes (not recommended for production; documented in README as expiring after 90 days in GitHub Actions artifacts)
- All deployments support both US and EU Honeycomb instances

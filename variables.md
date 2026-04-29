If using this repository as a template, you will need to set some variables in your repository settings. These variables are used in the Helm charts and other configurations.

## Repository Variables

| Name                                       | Value                                                    |
| ------------------------------------------ | -------------------------------------------------------- |
| `HONEYCOMB_REFINERY_TELEMETRY_API_ENDPOINT` | https://api.honeycomb.io (centralized us1 endpoint where all Refinery telemetry and K8s monitoring data lands) |
| `K8S_NAMESPACE`                            | hnytest or \<your-customer-name>                         |
| `DNS_NAME`                                 | Route 53 hostname for the us-east-1 (raas-us1) ingress   |
| `DNS_NAME_EU`                              | Route 53 hostname for the eu-west-1 (raas-eu1) ingress   |
| `DNS_NAME_US2`                             | Route 53 hostname for the us-east-2 (raas-us2) ingress   |
| `DNS_NAME_US4`                             | Route 53 hostname for the us-west-2 (raas-us4) ingress   |
| `DNS_NAME_IN1`                             | Route 53 hostname for the ap-south-1 (raas-in1) ingress  |
| `AWS_REGION`                               | eu-west-1 or us-east-1 — _consumed only by `tf-hny-triggers.yaml`_ |
| `CLUSTER_NAME`                             | raas-eu1 or raas-us1 — _consumed only by `tf-hny-triggers.yaml`_ |
| `HONEYCOMB_API_ENDPOINT`                   | https://api.eu1.honeycomb.io or https://api.honeycomb.io — _consumed only by `tf-hny-triggers.yaml`_ |

The Helm-deploy workflows (`refinery-deploy.yaml`, `k8s-monitoring-deploy.yaml`) deploy to every region in parallel via a matrix. Per-region values (region, cluster name, customer-facing Honeycomb API endpoint, DNS hostname variable name) are baked into the matrix in each workflow file — to add a region, edit the matrix and add the region's paired secrets and DNS variable (see below).

---

The following values will be available in Terraform outputs or the AWS console Please check the AWS console or the Terraform run logs after Terraform apply has successfully completed to find the values for these variables.

If looking for the values in the AWS console, please make sure to check the correct region (eu-west-1 or us-east-1) based on your deployment.

## Repository AWS Secrets

| Name                 | Where to Find Value                    |
| -------------------- | -------------------------------------- |
| `AWS_GH_EKS_ROLE`     | AWS IAM Console or TF Cloud run output |
| `ACM_ARN`             | AWS Certificate Manager                |
| `AWS_GH_EKS_ROLE_EU`  | AWS IAM Console                        |
| `ACM_ARN_EU`          | AWS Certificate Manager                |
| `AWS_GH_EKS_ROLE_US2` | AWS IAM Console                        |
| `ACM_ARN_US2`         | AWS Certificate Manager                |
| `AWS_GH_EKS_ROLE_US4` | AWS IAM Console                        |
| `ACM_ARN_US4`         | AWS Certificate Manager                |
| `AWS_GH_EKS_ROLE_IN1` | AWS IAM Console                        |
| `ACM_ARN_IN1`         | AWS Certificate Manager                |

## Repository Honeycomb Secrets

You may find these in your respective Honeycomb.io refinery-as-a-service team (US or EU).

| Name                         | Where to Find Value                                                                                            |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `REFINERY_HONEYCOMB_API_KEY` | Your Honeycomb.io refinery-as-a-service team (US or EU). Must be a key with permissions to create triggers.    |
| `REFINERY_QUERY_AUTH_TOKEN`  | User determined value. `C0ntains.L1ve.B33s` is the default value.                                              |
| `TF_STATE_PASSHRASE`         | User determined value.                                                                                         |
| `SLACK_RECIPIENT_CHANNEL`    | `#collab-hosted-refinery-for-pocs` is the default value. This is the channel where notifications will be sent. |

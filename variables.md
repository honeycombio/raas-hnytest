If using this repository as a template, you will need to set some variables in your repository settings. These variables are used in the Helm charts and other configurations.

## Repository Variables

| Name                     | Value                                                    |
| ------------------------ | -------------------------------------------------------- |
| `AWS_REGION`             | eu-west-1 or us-east-1                                   |
| `CLUSTER_NAME`           | raas-eu1 or raas-us1                                     |
| `HONEYCOMB_API_ENDPOINT` | https://api.eu1.honeycomb.io or https://api.honeycomb.io |
| `K8S_NAMESPACE`          | hnytest or \<your-customer-name>                         |

---

The following values will be available in Terraform outputs or the AWS console Please check the AWS console or the Terraform run logs after Terraform apply has successfully completed to find the values for these variables.

If looking for the values in the AWS console, please make sure to check the correct region (eu-west-1 or us-east-1) based on your deployment.

## Repository AWS Secrets

| Name                 | Where to Find Value                    |
| -------------------- | -------------------------------------- |
| `AWS_GH_EKS_ROLE`    | AWS IAM Console or TF Cloud run output |
| `ACM_ARN`            | AWS Certificate Manager                |
| `DNS_NAME`           | AWS Route 53                           |
| `AWS_GH_EKS_ROLE_EU` | AWS IAM Console                        |
| `ACM_ARN_EU`         | AWS Certificate Manager                |
| `DNS_NAME_EU`        | AWS Route 53                           |

## Repository Honeycomb Secrets

You may find these in your respective Honeycomb.io refinery-as-a-service team (US or EU).

| Name                         | Where to Find Value                                                                                            |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `REFINERY_HONEYCOMB_API_KEY` | Your Honeycomb.io refinery-as-a-service team (US or EU). Must be a key with permissions to create triggers.    |
| `REFINERY_QUERY_AUTH_TOKEN`  | User determined value. `C0ntains.L1ve.B33s` is the default value.                                              |
| `TF_STATE_PASSHRASE`         | User determined value.                                                                                         |
| `SLACK_RECIPIENT_CHANNEL`    | `#collab-hosted-refinery-for-pocs` is the default value. This is the channel where notifications will be sent. |

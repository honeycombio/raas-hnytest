# Honeycomb Refinery Cluster

This repository is for managing the helm chart for your Refinery cluster to use with your proof of concept work with Honeycomb sales.  The helm chart comes with some default values that the team believes will work well in most cases, but will likely need some review and tuning for your specific traffic and query considerations.

For more information about Refinery, please check out the docs on the Honeycomb website:
[Honeycomb Refinery Docs](https://docs.honeycomb.io/manage-data-volume/refinery/)

## Apply this helm chart

If you make updates to this helm chart, put in a Pull Request to the GitHub Repository and let your Solutions Architect know.  They will be able to approve your pull request and apply the helm chart to your Refinery cluster.

To apply this chart in your own Kubernetes environment:

1. Provision Kubernetes nodes dedicated to Refinery - since it is CPU, Memory _and_ Network intesive it's better to not try to make it coexist with other apps!
  * Ensure you apply labels to your nodes that match the selectors in this chart
2. Apply the secrets object
  ```
  NAMESPACE='mynamespace'
  kubectl apply -f refinery-secrets.yaml
  ```
3. Install the helm chart
  ```
  NAMESPACE='mynamespace'
  helm repo add honeycomb https://honeycombio.github.io/helm-charts
  helm install -n $NAMESPACE refinery honeycomb/refinery -f refinery-values.yaml --wait
  ```


Applying updates to the chart:
```
NAMESPACE='mynamespace'
helm repo update
helm upgrade -n $NAMESPACE refinery honeycomb/refinery -f refinery-values.yaml --wait
```


## Honeycomb Triggers via Terraform

This repository uses Terraform via the `honeycombio` provider to apply triggers to a given environment.
As an example only, it uses Github Actions with the [Terraform State Artifact](https://github.com/marketplace/actions/terraform-state-artifact) module to store TF state as an artifact in GHA.  It should be noted that artifacts expire after 90 days, so this is not recommended for production use cases.

Prequisites:
1. Create the following [Actions secrets in Github](/settings/secrets/actions)
  a. `HONEYCOMB_API_KEY` - should contain a configuration API key for the given environment
  b. `TF_STATE_PASSPHRASE` - should contain a randomly generated passphrase for encrypting TF state
2. Create the following [Actions environment variables in Github](/settings/variables/actions)
  a. `HONEYCOMB_API_ENDPOINT` - either `https://api.honeycomb.io` or `https://api.eu1.honeycomb.io`

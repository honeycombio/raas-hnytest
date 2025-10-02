variable "refinery_metrics_dataset" {
  type    = string
  default = "refinery-otel-metrics"
}

variable "slack_recipient_channel" {
  type    = string
  default = "#collab-hosted-refinery-for-pocs"
}

variable "create_slack_recipient" {
  type    = bool
  default = false
}

variable "refinery_metrics_dataset" {
  type    = string
  default = "refinery-metrics"
}

variable "create_slack_recipient" {
  type    = bool
  default = false
}

variable "slack_recipient_channel" {
  type    = string
  default = "#exp-hosted-refinery-for-pocs"
}

variable "existing_slack_recipient_id" {
  type    = string
  default = "C050ZJGP2KW" # Default to the channel ID for #collab-hosted-refinery-for-pocs
}

resource "honeycombio_slack_recipient" "alerts" {
  channel = var.slack_recipient_channel
}

output "slack_recipient_id" {
  value = honeycombio_slack_recipient.alerts.id
}

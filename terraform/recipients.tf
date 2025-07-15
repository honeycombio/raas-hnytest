resource "honeycombio_slack_recipient" "alerts" {
  channel = var.slack_recipient_channel
}

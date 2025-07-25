# create a Slack recipient if var.create_slack_recipient is true
resource "honeycombio_slack_recipient" "alerts" {
  count   = var.create_slack_recipient ? 1 : 0
  channel = var.slack_recipient_channel
}

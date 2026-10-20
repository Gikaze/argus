# Alerting: SNS topic that sends the Argus alerts by email
resource "aws_sns_topic" "alerts" {
  name = "argus-alerts"
}

# Email subscription: AWS sends a confirmation link first
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

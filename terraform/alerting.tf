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

# CloudWatch: watch the monitoring server itself.
# Argus cannot alert about its own failure, so AWS watches srv-argus from outside.
resource "aws_cloudwatch_metric_alarm" "argus_down" {
  alarm_name          = "argus-monitoring-server-down"
  alarm_description   = "srv-argus failed its status checks or stopped reporting: Argus alerts are offline"
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"          # free metric, checked by AWS every minute
  dimensions          = { InstanceId = aws_instance.argus.id }
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2                            # 2 bad minutes in a row
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1
  treat_missing_data  = "breaching"                  # a stopped instance sends nothing: treat silence as down
  alarm_actions       = [aws_sns_topic.alerts.arn]   # email when it goes down
  ok_actions          = [aws_sns_topic.alerts.arn]   # email when it is back
}





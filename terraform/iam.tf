# IAM: let srv-argus publish alerts to the SNS topic, and nothing else

# Who may use the role: EC2 instances
resource "aws_iam_role" "argus" {
  name = "argus-monitoring"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# What the role allows: publishing to the Argus topic only
resource "aws_iam_role_policy" "publish_alerts" {
  name = "publish-argus-alerts"
  role = aws_iam_role.argus.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sns:Publish"
      Resource = aws_sns_topic.alerts.arn
    }]
  })
}

# Instance profile: the "holder" that attaches the role to an EC2 instance
resource "aws_iam_instance_profile" "argus" {
  name = "argus-monitoring"
  role = aws_iam_role.argus.name
}

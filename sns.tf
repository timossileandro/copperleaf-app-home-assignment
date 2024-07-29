# SNS Topic
resource "aws_sns_topic" "alarm_topic" {
  name              = "${var.env}-${var.company}-${var.app}-sns-alarms-01"
  kms_master_key_id = "alias/aws/sns"
  tags              = local.tags
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "alarm_email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email_sns
}
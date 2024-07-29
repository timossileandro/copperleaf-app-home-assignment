# Create a log group for the ECS task
resource "aws_cloudwatch_log_group" "nginx_log_group" {
  name              = "/ecs/nginx"
  retention_in_days = 365
  tags              = local.tags
}


# NLB Unhealthy Host Count Alarm
resource "aws_cloudwatch_metric_alarm" "nlb_unhealthy_host_count" {
  alarm_name          = "${var.env}-${var.company}-${var.app}-nbl-unhealthy-Count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm when NLB has more than 1 unhealthy host"
  dimensions = {
    LoadBalancer = aws_lb.nat_lb.arn_suffix
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm_topic.arn]
  tags            = local.tags
}

# NLB Healthy Host Count Alarm
resource "aws_cloudwatch_metric_alarm" "nlb_healthy_host_count" {
  alarm_name          = "${var.env}-${var.company}-${var.app}-nlb-healthy-count"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alarm when NLB has no healthy hosts"
  dimensions = {
    LoadBalancer = aws_lb.nat_lb.arn_suffix
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm_topic.arn]
  tags            = local.tags
}

# NLB High Active Flow Count Alarm
resource "aws_cloudwatch_metric_alarm" "nlb_high_active_flow_count" {
  alarm_name          = "${var.env}-${var.company}-${var.app}-nlb-high-active-flow-count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ActiveFlowCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1000"
  alarm_description   = "Alarm when NLB has more than 1000 active flows"
  dimensions = {
    LoadBalancer = aws_lb.nat_lb.arn_suffix
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm_topic.arn]
  tags            = local.tags
}
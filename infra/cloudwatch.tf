resource "aws_cloudwatch_log_group" "app" {
  name              = "/dice-roller/app"
  retention_in_days = 14

  tags = merge(local.tags, {
    Name = "dice-roller-app-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "app_high_cpu" {
  alarm_name          = "dice-roller-app-high-cpu"
  alarm_description   = "CPU utilization of the Dice Roller EC2 instance is above 80%."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"

  tags = merge(local.tags, {
    Name = "dice-roller-app-high-cpu"
  })
}
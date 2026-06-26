resource "aws_cloudwatch_log_group" "app" {
  name              = "/dice-roller/app"
  retention_in_days = 14

  tags = merge(local.tags, {
    Name = "dice-roller-app-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "app_high_cpu" {
  alarm_name  = "dice-roller-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  tags = merge(local.tags, {
    Name = "dice-roller-app-high-cpu"
  })
}
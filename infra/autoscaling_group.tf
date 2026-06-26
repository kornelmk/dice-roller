resource "aws_autoscaling_group" "app" {
  name = "dice-roller-asg"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [aws_lb_target_group.app.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "dice-roller-asg-instance"
    propagate_at_launch = true
  }
}
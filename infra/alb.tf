resource "aws_lb" "app" {
  name               = "dice-roller-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = merge(local.tags, {
    Name = "dice-roller-alb"
  })
}
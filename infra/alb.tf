resource "aws_lb" "app" {
  name               = "dice-roller-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = aws_subnet.public[*].id

  tags = merge(local.tags, {
    Name = "dice-roller-alb"
  })
}
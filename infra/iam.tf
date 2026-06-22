resource "aws_iam_role" "app" {
  name = "dice-roller-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.tags, {
    Name = "dice-roller-app-role"
  })
}

resource "aws_iam_role_policy" "app_cloudwatch_logs" {
  name = "dice-roller-app-cloudwatch-logs"
  role = aws_iam_role.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.app.arn}:*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app" {
  name = "dice-roller-app-profile"
  role = aws_iam_role.app.name

  tags = merge(local.tags, {
    Name = "dice-roller-app-profile"
  })
}
resource "aws_instance" "frontend" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

docker run -d \
  -p 8501:8501 \
  kornelmk/dice-roller-frontend:latest
EOF
  )

  tags = merge(local.tags, {
    Name = "frontend"
  })
}
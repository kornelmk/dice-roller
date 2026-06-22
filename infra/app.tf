resource "aws_instance" "app" {
  ami           = "ami-0d45a4eba03d1e2cf"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  key_name = "dice-roller-key"

  iam_instance_profile = aws_iam_instance_profile.app.name

  user_data = base64encode(<<EOF
#!/bin/bash
set -ex

yum update -y

# install docker + git
yum install -y docker git

systemctl enable docker
systemctl start docker

# install docker compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# create app directory only
mkdir -p /home/ec2-user/app
chown -R ec2-user:ec2-user /home/ec2-user/app

# add permissions
usermod -a -G docker ec2-user

EOF
  )

  tags = merge(local.tags, {
    Name = "dice-roller-app"
  })
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id

  tags = merge(local.tags, {
    Name = "dice-roller-eip"
  })
}
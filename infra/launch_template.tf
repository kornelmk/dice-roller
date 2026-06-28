resource "aws_launch_template" "app" {
  name_prefix   = "dice-roller-"
  image_id      = "ami-0d45a4eba03d1e2cf"
  instance_type = "t3.micro"

  key_name = "dice-roller-key"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

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

# clone repo
cd /home/ec2-user/app
git clone https://github.com/kornelmk/dice-roller.git .

# set version
echo "APP_VERSION=${var.app_version}" > .env

# set hostname
HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)
echo "HOSTNAME=$HOSTNAME" >> .env

# run app
cd infra
docker-compose up -d

EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      Name = "dice-roller-asg-instance"
    })
  }
}
resource "aws_instance" "app" {
  ami           = "ami-0d45a4eba03d1e2cf"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  key_name = "dice-roller-key"

  user_data = base64encode(<<EOF
#!/bin/bash
set -ex

yum update -y

# install docker
yum install -y docker
systemctl enable docker
systemctl start docker

# install docker compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# clone repo
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

git clone https://github.com/kornelmk/dice-roller.git .

# run docker-compose
cd infra
docker-compose pull || true
docker-compose up -d

EOF
  )

  tags = merge(local.tags, {
    Name = "dice-roller-app"
  })
}
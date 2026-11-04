
resource "aws_instance" "web" {
  ami                    = "ami-0990bd2af79bd53a7"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_web.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm.name

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    # Install Docker
    dnf install -y docker

    # Start Docker automatically
    systemctl enable --now docker

    # Install Docker Compose plugin
    mkdir -p /usr/local/lib/docker/cli-plugins

    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
      -o /usr/local/lib/docker/cli-plugins/docker-compose

    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # Create application directory
    mkdir -p /opt/todo-app
    chmod 755 /opt/todo-app

    # Verify installation
    docker --version
    docker compose version
  EOF

  tags = {
    Name        = "platform-lab-web"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

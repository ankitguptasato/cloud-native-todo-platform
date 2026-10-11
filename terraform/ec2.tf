
resource "aws_instance" "web" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_web.id]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo '<h1>Platform Lab - Nginx is Running!</h1>' > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name        = "platform-lab-web"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}
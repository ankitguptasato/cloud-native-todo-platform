
resource "aws_security_group" "public_web" {
  name        = "platform-lab-public-web-sg"
  description = "Security group for the platform lab web tier"
  vpc_id      = aws_vpc.platform.id

  tags = {
    Name        = "platform-lab-public-web-sg"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_web_http" {
  security_group_id = aws_security_group.public_web.id

  description = "Allow HTTP traffic for the learning web tier"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_web_outbound" {
  security_group_id = aws_security_group.public_web.id

  description = "Allow outbound IPv4 traffic for the learning web tier"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_security_group" "alb" {
  name        = "platform-lab-alb-sg"
  description = "Allow HTTP traffic to the application load balancer"
  vpc_id      = aws_vpc.platform.id

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "platform-lab-alb-sg"
    Environment = "learning"
  }
}
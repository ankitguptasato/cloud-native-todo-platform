
resource "aws_vpc" "platform" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "platform-lab-vpc"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "platform" {
  vpc_id = aws_vpc.platform.id

  tags = {
    Name        = "platform-lab-igw"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}
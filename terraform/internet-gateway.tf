
resource "aws_internet_gateway" "platform" {
  vpc_id = aws_vpc.platform.id

  tags = {
    Name        = "platform-lab-igw"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "platform-lab-nat-eip"
    Environment = "learning"
  }
}

resource "aws_nat_gateway" "platform" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "platform-lab-nat"
    Environment = "learning"
  }

  depends_on = [aws_internet_gateway.platform]
}
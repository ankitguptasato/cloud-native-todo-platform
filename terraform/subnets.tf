
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.platform.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "platform-lab-public-subnet"
    Environment = "learning"
    Tier        = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.platform.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name        = "platform-lab-private-subnet"
    Environment = "learning"
    Tier        = "private"
  }
}
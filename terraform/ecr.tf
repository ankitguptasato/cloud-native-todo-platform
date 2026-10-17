resource "aws_ecr_repository" "backend" {
  name                 = "ankit-todo-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "ankit-todo-backend"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "ankit-todo-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "ankit-todo-frontend"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}
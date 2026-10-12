variable "vpc_cidr" {
  description = "CIDR range for the platform lab VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability Zone for the platform lab subnets"
  type        = string
  default     = "ap-northeast-1a"
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "second_availability_zone" {
  description = "Availability Zone for the second public subnet"
  type        = string
  default     = "ap-northeast-1c"
}

variable "second_public_subnet_cidr" {
  description = "CIDR range for the second public subnet"
  type        = string
  default     = "10.0.3.0/24"
}
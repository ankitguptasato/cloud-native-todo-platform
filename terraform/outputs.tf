output "aws_account_id" {
  description = "AWS account Terraform is connected to"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_user_arn" {
  description = "AWS identity Terraform is using"
  value       = data.aws_caller_identity.current.arn
}

output "web_instance_id" {
  description = "ID of the platform lab web server"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.web.public_ip
}

output "web_public_dns" {
  description = "Public DNS name of the web server"
  value       = aws_instance.web.public_dns
}
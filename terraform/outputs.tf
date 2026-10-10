output "aws_account_id" {
  description = "AWS account Terraform is connected to"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_user_arn" {
  description = "AWS identity Terraform is using"
  value       = data.aws_caller_identity.current.arn
}
output "lambda_execution_role_arn" {
  value = { for k, role in aws_iam_role.lambda_execution_role : k => role.arn }
}

output "lambda_execution_role_name" {
  value = { for k, role in aws_iam_role.lambda_execution_role : k => role.name }
}

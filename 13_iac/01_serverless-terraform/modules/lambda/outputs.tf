output "lambda_function_arn" {
  value = { for k, lambda in aws_lambda_function.this : k => lambda.arn }
}

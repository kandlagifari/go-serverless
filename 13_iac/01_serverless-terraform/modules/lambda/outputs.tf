output "lambda_function_arn" {
  value = { for k, lambda in aws_lambda_function.this : k => lambda.arn }
}

output "lambda_function_invoke_arn" {
  value = { for k, lambda in aws_lambda_function.this : k => lambda.invoke_arn }
}

output "dynamodb_table_arn" {
  value = { for k, dynamodb_table in aws_dynamodb_table.this : k => dynamodb_table.arn }
}

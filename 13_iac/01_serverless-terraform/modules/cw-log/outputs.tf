output "cw_log_arn" {
  value = { for k, cw_log in aws_cloudwatch_log_group.this : k => cw_log.arn }
}

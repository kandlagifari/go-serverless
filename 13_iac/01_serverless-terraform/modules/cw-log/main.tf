resource "aws_cloudwatch_log_group" "this" {
  for_each = var.cloudwatch_log_group
  name     = each.value["cw_log_name"]
}

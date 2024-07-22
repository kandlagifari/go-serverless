resource "aws_dynamodb_table" "this" {
  for_each       = var.dynamodb_details
  name           = each.value["dynamodb_table_name"]
  billing_mode   = each.value["dynamodb_table_billing_mode"]
  read_capacity  = each.value["dynamodb_table_read_capacity"]
  write_capacity = each.value["dynamodb_table_write_capacity"]
  hash_key       = each.value["dynamodb_table_hash_key"]

  dynamic "attribute" {
    for_each = var.dynamodb_details
    content {
      name = attribute.value["dynamodb_attribute_name"]
      type = attribute.value["dynamodb_attribute_type"]
    }
  }
}

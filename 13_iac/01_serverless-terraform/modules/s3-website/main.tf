resource "aws_s3_bucket" "this" {
  for_each = var.s3_bucket_details
  bucket   = each.value["bucket_name"]
}

resource "aws_s3_bucket_website_configuration" "this" {
  for_each = var.s3_bucket_details
  bucket   = aws_s3_bucket.this[each.key].bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = var.s3_bucket_details
  bucket   = aws_s3_bucket.this[each.key].bucket

  rule {
    id = each.value["rule_id"]
    expiration {
      days = each.value["rule_expiration_days"]
    }

    status = "Enabled"
  }
}

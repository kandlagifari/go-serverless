output "s3_bucket_name" {
  value = { for k, s3_bucket in aws_s3_bucket.this : k => s3_bucket.id }
}
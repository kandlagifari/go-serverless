data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  bucket = "assalamualaikumserverless.cloud"
}
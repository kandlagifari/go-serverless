/* ------------------------------------------- Region ------------------------------------------- */

variable "region" {
  type        = string
  description = "Region where the resources will be provisioned."
  default     = "us-east-1"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}


/* ------------------------------------------- Provider ----------------------------------------- */

# variable "aws_profile" {
#   type        = string
#   description = "AWS PROFILE environment variable to specify a named profile"
#   default     = "default"
# }

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "local"
}

variable "apps_name" {
  type        = string
  description = "Application name"
  default     = "localstack"
}

variable "tags" {
  type        = map(string)
  description = "Default Tag"
  default = {
    Environment = "local"
    Project     = "localstack"
  }
}


/* ---------------------------------- DynamoDB for Go Backend ----------------------------------- */

variable "dynamodb_details" {
  type = map(object({
    dynamodb_table_name           = string
    dynamodb_table_billing_mode   = string
    dynamodb_table_read_capacity  = number
    dynamodb_table_write_capacity = number
    dynamodb_table_hash_key       = string
    dynamodb_attribute_name       = string
    dynamodb_attribute_type       = string
  }))
}


/* ------------------------------------- CW Log for Lambda -------------------------------------- */

variable "cloudwatch_log_group" {
  type = map(object({
    cw_log_name = string
  }))
}


/* ----------------------------------------- Lambda Role ---------------------------------------- */

variable "lambda_execution_role" {
  type = map(object({
    role_name = string
  }))
}


/* ----------------------------------- Lambda for Go Backend ------------------------------------ */

variable "lambda_code_file" {
  type = map(object({
    lambda_source_file = string
    lambda_output_path = string
  }))
}

variable "lambda_function_config" {
  type = map(object({
    lambda_function_name  = string
    lambda_handler        = string
    lambda_runtime        = string
    lambda_timeout        = number
    environment_variables = map(string)
  }))
}


/* ----------------------------------- S3 for Angular Frontend ---------------------------------- */

variable "s3_bucket_details" {
  type = map(object({
    bucket_name          = string
    rule_id              = string
    rule_expiration_days = number
  }))
}

/* ----------------------------- Terraform Block ---------------------------- */

terraform {
  # required_version = "~> 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }

  backend "s3" {
    bucket = "terraform-state-localstack-000000000000-us-east-1"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-lock-localstack-000000000000-us-east-1"
    encrypt        = true
  }
}


/* ----------------------------- Provider Block ----------------------------- */

provider "aws" {
  # LocalStack Setup
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # LocalStack Endpoint
  endpoints {
    apigateway   = "http://localhost:4566"
    apigatewayv2 = "http://localhost:4566"
    cloudwatch   = "http://localhost:4566"
    dynamodb     = "http://localhost:4566"
    iam          = "http://localhost:4566"
    lambda       = "http://localhost:4566"
    s3           = "http://s3.localhost.localstack.cloud:4566"
    sts          = "http://localhost:4566"
  }
}

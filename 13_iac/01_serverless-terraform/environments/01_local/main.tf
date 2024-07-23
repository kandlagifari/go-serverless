/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                DynamoDB for Go Backend                                             */
/* ------------------------------------------------------------------------------------------------------------------ */

module "local_dynamo_db" {
  source           = "../../modules/dynamo-db"
  dynamodb_details = var.dynamodb_details
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                CW Log Group for Lambda                                             */
/* ------------------------------------------------------------------------------------------------------------------ */

module "local_cw_log_lambda" {
  source               = "../../modules/cw-log"
  cloudwatch_log_group = var.cloudwatch_log_group
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                  IAM Role for Lambda                                               */
/* ------------------------------------------------------------------------------------------------------------------ */

module "local_lambda_role" {
  source                = "../../modules/iam/lambda-role"
  lambda_execution_role = var.lambda_execution_role
  region                = data.aws_region.current.name
  account_id            = data.aws_caller_identity.current.account_id
  lambda_execution_policy = {
    "find_all" = {
      policy_name              = "local-go-backend-find-all-lambda-policy"
      cloudwatch_log_group_arn = module.local_cw_log_lambda.cw_log_arn["find_all"]
      dynamodb_table_arn       = module.local_dynamo_db.dynamodb_table_arn["movies"]
    },
    "find_one" = {
      policy_name              = "local-go-backend-find-one-lambda-policy"
      cloudwatch_log_group_arn = module.local_cw_log_lambda.cw_log_arn["find_one"]
      dynamodb_table_arn       = module.local_dynamo_db.dynamodb_table_arn["movies"]
    },
    "insert" = {
      policy_name              = "local-go-backend-insert-lambda-policy"
      cloudwatch_log_group_arn = module.local_cw_log_lambda.cw_log_arn["insert"]
      dynamodb_table_arn       = module.local_dynamo_db.dynamodb_table_arn["movies"]
    },
    "delete" = {
      policy_name              = "local-go-backend-delete-lambda-policy"
      cloudwatch_log_group_arn = module.local_cw_log_lambda.cw_log_arn["delete"]
      dynamodb_table_arn       = module.local_dynamo_db.dynamodb_table_arn["movies"]
    }
  }
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                               Lambda for Go Backend                                                */
/* ------------------------------------------------------------------------------------------------------------------ */

module "local_lambda_function" {
  source                 = "../../modules/lambda"
  lambda_code_file       = var.lambda_code_file
  lambda_function_config = var.lambda_function_config
  lambda_role            = module.local_lambda_role.lambda_execution_role_arn
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                             API Gateway for Go Backend                                             */
/* ------------------------------------------------------------------------------------------------------------------ */

resource "aws_api_gateway_rest_api" "api" {
  name        = "TwoDimensionalAPI"
  description = "Two Dimensional RESTful API"
}

resource "aws_api_gateway_resource" "path_movies" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "movies"
}

resource "aws_api_gateway_resource" "path_id_movie" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.path_movies.id
  path_part   = "{id}"
}

module "local_api_gateway" {
  source = "../../modules/api-gw"
  api_gateway_details = {
    "find_all" = {
      rest_api_id         = aws_api_gateway_rest_api.api.id
      resource_id         = aws_api_gateway_resource.path_movies.id
      http_method         = "GET"
      invoke_uri          = module.local_lambda_function.lambda_function_invoke_arn
      lambda_function_arn = module.local_lambda_function.lambda_function_arn
      api_execution_arn   = aws_api_gateway_rest_api.api.execution_arn
    },
    "find_one" = {
      rest_api_id         = aws_api_gateway_rest_api.api.id
      resource_id         = aws_api_gateway_resource.path_id_movie.id
      http_method         = "GET"
      invoke_uri          = module.local_lambda_function.lambda_function_invoke_arn
      lambda_function_arn = module.local_lambda_function.lambda_function_arn
      api_execution_arn   = aws_api_gateway_rest_api.api.execution_arn
    },
    "insert" = {
      rest_api_id         = aws_api_gateway_rest_api.api.id
      resource_id         = aws_api_gateway_resource.path_movies.id
      http_method         = "POST"
      invoke_uri          = module.local_lambda_function.lambda_function_invoke_arn
      lambda_function_arn = module.local_lambda_function.lambda_function_arn
      api_execution_arn   = aws_api_gateway_rest_api.api.execution_arn
    },
    "delete" = {
      rest_api_id         = aws_api_gateway_rest_api.api.id
      resource_id         = aws_api_gateway_resource.path_movies.id
      http_method         = "DELETE"
      invoke_uri          = module.local_lambda_function.lambda_function_invoke_arn
      lambda_function_arn = module.local_lambda_function.lambda_function_arn
      api_execution_arn   = aws_api_gateway_rest_api.api.execution_arn
    }
  }
}

resource "aws_api_gateway_deployment" "local" {
  depends_on = [
    module.local_api_gateway
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "local"
}



/* ------------------------------------------------------------------------------------------------------------------ */
/*                                                 S3 Static Website                                                  */
/* ------------------------------------------------------------------------------------------------------------------ */

module "local_s3_website" {
  source            = "../../modules/s3-website"
  s3_bucket_details = var.s3_bucket_details
}

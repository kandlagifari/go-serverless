/* ----------------------------------------------------- Provider --------------------------------------------------- */

# aws_profile = "localstack-kandla"
environment = "local"


/* -------------------------------------------- DynamoDB for Go Backend --------------------------------------------- */

dynamodb_details = {
  "movies" = {
    dynamodb_table_name           = "movies"
    dynamodb_table_billing_mode   = "PROVISIONED"
    dynamodb_table_read_capacity  = 5
    dynamodb_table_write_capacity = 5
    dynamodb_table_hash_key       = "ID"
    dynamodb_attribute_name       = "ID"
    dynamodb_attribute_type       = "S"
  }
}


/* ------------------------------------------------ CW Log for Lambda ----------------------------------------------- */

cloudwatch_log_group = {
  "find_all" = {
    cw_log_name = "/aws/lambda/local-go-backend-find-all-lambda"
  },
  "find_one" = {
    cw_log_name = "/aws/lambda/local-go-backend-find-one-lambda"
  },
  "insert" = {
    cw_log_name = "/aws/lambda/local-go-backend-insert-lambda"
  },
  "delete" = {
    cw_log_name = "/aws/lambda/local-go-backend-delete-lambda"
  }
}


/* --------------------------------------------------- Lambda Role -------------------------------------------------- */

lambda_execution_role = {
  "find_all" = {
    role_name = "local-go-backend-find-all-lambda-role"
  },
  "find_one" = {
    role_name = "local-go-backend-find-one-lambda-role"
  },
  "insert" = {
    role_name = "local-go-backend-insert-lambda-role"
  },
  "delete" = {
    role_name = "local-go-backend-delete-lambda-role"
  }
}


/* ---------------------------------------------  Lambda for Go Backend --------------------------------------------- */

lambda_code_file = {
  "find_all" = {
    lambda_source_file = "go-backend/findAll/bootstrap"
    lambda_output_path = "environments/01_local/fndall-deployment.zip"
  },
  "find_one" = {
    lambda_source_file = "go-backend/findOne/bootstrap"
    lambda_output_path = "environments/01_local/fndone-deployment.zip"
  },
  "insert" = {
    lambda_source_file = "go-backend/insert/bootstrap"
    lambda_output_path = "environments/01_local/insert-deployment.zip"
  },
  "delete" = {
    lambda_source_file = "go-backend/delete/bootstrap"
    lambda_output_path = "environments/01_local/delete-deployment.zip"
  }
}

lambda_function_config = {
  "find_all" = {
    lambda_function_name = "local-go-backend-find-all-lambda"
    lambda_handler       = "bootstrap"
    lambda_runtime       = "provided.al2023"
    lambda_timeout       = 120
    environment_variables = {
      TABLE_NAME = "movies"
    }
  },
  "find_one" = {
    lambda_function_name = "local-go-backend-find-one-lambda"
    lambda_handler       = "bootstrap"
    lambda_runtime       = "provided.al2023"
    lambda_timeout       = 120
    environment_variables = {
      TABLE_NAME = "movies"
    }
  },
  "insert" = {
    lambda_function_name = "local-go-backend-insert-lambda"
    lambda_handler       = "bootstrap"
    lambda_runtime       = "provided.al2023"
    lambda_timeout       = 120
    environment_variables = {
      TABLE_NAME = "movies"
    }
  },
  "delete" = {
    lambda_function_name = "local-go-backend-delete-lambda"
    lambda_handler       = "bootstrap"
    lambda_runtime       = "provided.al2023"
    lambda_timeout       = 120
    environment_variables = {
      TABLE_NAME = "movies"
    }
  }
}

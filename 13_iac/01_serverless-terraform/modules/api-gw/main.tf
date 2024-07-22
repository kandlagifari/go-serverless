resource "aws_api_gateway_method" "request_method" {
  for_each      = var.api_gateway_details
  rest_api_id   = each.value["rest_api_id"]
  resource_id   = each.value["resource_id"]
  http_method   = each.value["http_method"]
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_integration" {
  for_each    = var.api_gateway_details
  rest_api_id = each.value["rest_api_id"]
  resource_id = aws_api_gateway_method.request_method[each.key].resource_id
  http_method = aws_api_gateway_method.request_method[each.key].http_method
  type        = "AWS_PROXY"
  uri         = each.value["invoke_uri"]

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  for_each      = var.api_gateway_details
  function_name = each.value["lambda_function_arn"]
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${each.value["api_execution_arn"]}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_method" {
  for_each    = var.api_gateway_details
  rest_api_id = each.value["rest_api_id"]
  resource_id = aws_api_gateway_method.request_method[each.key].resource_id
  http_method = aws_api_gateway_integration.request_integration[each.key].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  for_each    = var.api_gateway_details
  rest_api_id = each.value["rest_api_id"]
  resource_id = aws_api_gateway_method.request_method[each.key].resource_id
  http_method = aws_api_gateway_method_response.response_method[each.key].http_method
  status_code = aws_api_gateway_method_response.response_method[each.key].status_code

  response_templates = {
    "application/json" = ""
  }
}

data "archive_file" "lambda_zip" {
  for_each = var.lambda_code_file
  type     = "zip"

  source_file = "${path.module}/../../${each.value["lambda_source_file"]}"
  output_path = "${path.module}/../../${each.value["lambda_output_path"]}"
}

resource "aws_lambda_function" "this" {
  for_each      = var.lambda_function_config
  filename      = substr(data.archive_file.lambda_zip[each.key].output_path, -21, -1)
  function_name = each.value["lambda_function_name"]
  role          = var.lambda_role[each.key]
  handler       = each.value["lambda_handler"]

  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256

  runtime = each.value["lambda_runtime"]
  timeout = each.value["lambda_timeout"]
}

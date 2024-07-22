resource "aws_iam_role" "lambda_execution_role" {
  for_each = var.lambda_execution_role
  name     = each.value["role_name"]
  path     = "/"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachments" {
  for_each   = var.lambda_execution_role
  policy_arn = aws_iam_policy.lambda_execution_policy[each.key].arn
  role       = aws_iam_role.lambda_execution_role[each.key].name
}

resource "aws_iam_policy" "lambda_execution_policy" {
  for_each = var.lambda_execution_policy
  name     = each.value["policy_name"]
  path     = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CreateCloudWatchLogGroup",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup"
      ],
      "Resource" : "arn:aws:logs:${var.region}:${var.account_id}:*"
    },
    {
      "Sid": "PushLogsToCloudWatch",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" : "${each.value["cloudwatch_log_group_arn"]}"
    },
    {
      "Sid": "ScanDynamoDB",
      "Effect": "Allow",
      "Action": "dynamodb:Scan",
      "Resource": "${each.value["dynamodb_table_arn"]}"
    },
    {
      "Sid": "GetItemDynamoDB",
      "Effect": "Allow",
      "Action": "dynamodb:GetItem",
      "Resource": "${each.value["dynamodb_table_arn"]}"
    },
    {
      "Sid": "PutItemDynamoDB",
      "Effect": "Allow",
      "Action": "dynamodb:PutItem",
      "Resource": "${each.value["dynamodb_table_arn"]}"
    } 
  ]
}
EOF
}

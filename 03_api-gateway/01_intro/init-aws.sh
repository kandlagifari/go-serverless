#!/bin/bash

echo "Create S3 Bucket"
awslocal s3api create-bucket \
    --bucket assalamualaikum-serverless-go-bucket

echo "Create IAM Policy"
awslocal iam create-policy \
    --policy-name PushLogsToCloudWatch \
    --policy-document file:///opt/code/localstack/iam-policy/lambda-cw-policy.json

echo "Create IAM Role"
awslocal iam create-role \
    --role-name AssalamualaikumServerlessRole \
    --assume-role-policy-document file:///opt/code/localstack/iam-role/lambda-assume-role.json

echo "Upload ZIP file"
awslocal s3 cp /opt/code/localstack/deployment.zip s3://assalamualaikum-serverless-go-bucket

echo "Create the Lambda function and capture the ARN"
LAMBDA_ARN=$(awslocal lambda create-function \
    --function-name AssalamualaikumServerless \
    --runtime provided.al2023 \
    --handler bootstrap \
    --role arn:aws:iam::000000000000:role/AssalamualaikumServerlessRole \
    --code S3Bucket=assalamualaikum-serverless-go-bucket,S3Key=deployment.zip \
    --query 'FunctionArn' \
    --output text)

echo "Create the API"
API_ID=$(awslocal apigateway create-rest-api \
    --name 'assalamualaikum-api' \
    --query 'id' \
    --output text)

echo "Get the root resource ID"
ROOT_RESOURCE_ID=$(awslocal apigateway get-resources \
    --rest-api-id $API_ID \
    --query 'items[?path==`/`].id' \
    --output text)

echo "Create a new resource"
RESOURCE_ID=$(awslocal apigateway create-resource \
    --rest-api-id $API_ID \
    --parent-id $ROOT_RESOURCE_ID \
    --path-part AssalamualaikumServerless \
    --query 'id' \
    --output text)

echo "Create a method ANY for the new resource"
awslocal apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method ANY \
    --authorization-type "NONE"

echo "Integrate the method with the Lambda function"
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $RESOURCE_ID \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/$LAMBDA_ARN/invocations

echo "Deploy the API"
awslocal apigateway create-deployment \
    --rest-api-id $API_ID \
    --stage-name staging

echo "http://$API_ID.execute-api.localhost.localstack.cloud:4566/staging/AssalamualaikumServerless"

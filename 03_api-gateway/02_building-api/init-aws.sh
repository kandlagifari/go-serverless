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

echo "Upload ZIP file findAll"
awslocal s3 cp /opt/code/localstack/findAll/deployment.zip s3://assalamualaikum-serverless-go-bucket/findAll/deployment.zip

echo "Upload ZIP file findOne"
awslocal s3 cp /opt/code/localstack/findOne/deployment.zip s3://assalamualaikum-serverless-go-bucket/findOne/deployment.zip

echo "Upload ZIP file insert"
awslocal s3 cp /opt/code/localstack/insert/deployment.zip s3://assalamualaikum-serverless-go-bucket/insert/deployment.zip

echo "Create the Lambda function FindAllMovies"
LAMBDA_FIND_ALL_ARN=$(awslocal lambda create-function \
    --function-name FindAllMovies \
    --runtime provided.al2023 \
    --handler bootstrap \
    --role arn:aws:iam::000000000000:role/AssalamualaikumServerlessRole \
    --code S3Bucket=assalamualaikum-serverless-go-bucket,S3Key=findAll/deployment.zip \
    --query 'FunctionArn' \
    --output text)

echo "Create the Lambda function FindOneMovie"
LAMBDA_FIND_ONE_ARN=$(awslocal lambda create-function \
    --function-name FindOneMovie \
    --runtime provided.al2023 \
    --handler bootstrap \
    --role arn:aws:iam::000000000000:role/AssalamualaikumServerlessRole \
    --code S3Bucket=assalamualaikum-serverless-go-bucket,S3Key=findOne/deployment.zip \
    --query 'FunctionArn' \
    --output text)

echo "Create the Lambda function  InsertMovie"
LAMBDA_INSERT_ARN=$(awslocal lambda create-function \
    --function-name  InsertMovie \
    --runtime provided.al2023 \
    --handler bootstrap \
    --role arn:aws:iam::000000000000:role/AssalamualaikumServerlessRole \
    --code S3Bucket=assalamualaikum-serverless-go-bucket,S3Key=insert/deployment.zip \
    --query 'FunctionArn' \
    --output text)

echo "Create the API with Regional Endpoint Configuration"
API_ID=$(awslocal apigateway create-rest-api \
    --name 'MoviesAPI' \
    --description 'Upcoming movies API' \
    --endpoint-configuration types="REGIONAL" \
    --query 'id' \
    --output text)

echo "Get the root resource ID"
ROOT_RESOURCE_ID=$(awslocal apigateway get-resources \
    --rest-api-id $API_ID \
    --query 'items[?path==`/`].id' \
    --output text)

echo "Create a new resource with a path parameter (e.g., "/movies")"
MOVIES_RESOURCE_ID=$(awslocal apigateway create-resource \
    --rest-api-id $API_ID \
    --parent-id $ROOT_RESOURCE_ID \
    --path-part movies \
    --query 'id' \
    --output text)

echo "Create a new resource with a path parameter (e.g., "/movies/{id}")"
CHILD_MOVIE_RESOURCE_ID=$(awslocal apigateway create-resource \
    --rest-api-id $API_ID \
    --parent-id $MOVIES_RESOURCE_ID \
    --path-part {id} \
    --query 'id' \
    --output text)

echo "Create a method GET for the resource /movies"
awslocal apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $MOVIES_RESOURCE_ID \
    --http-method GET \
    --authorization-type "NONE"

echo "Create a method GET for the resource /movies/{id}"
awslocal apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $CHILD_MOVIE_RESOURCE_ID \
    --http-method GET \
    --authorization-type "NONE"

echo "Create a method POST for the resource /movies"
awslocal apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id $MOVIES_RESOURCE_ID \
    --http-method POST \
    --authorization-type "NONE"

echo "Integrate the method with the Lambda function FindAllMovies"
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $MOVIES_RESOURCE_ID \
    --http-method GET \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/$LAMBDA_FIND_ALL_ARN/invocations

echo "Integrate the method with the Lambda function FindOneMovie"
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $CHILD_MOVIE_RESOURCE_ID \
    --http-method GET \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/$LAMBDA_FIND_ONE_ARN/invocations

echo "Integrate the method with the Lambda function InsertMovie"
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $MOVIES_RESOURCE_ID \
    --http-method POST \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/$LAMBDA_INSERT_ARN/invocations

echo "Deploy the API"
awslocal apigateway create-deployment \
    --rest-api-id $API_ID \
    --stage-name staging

echo "http://$API_ID.execute-api.localhost.localstack.cloud:4566/staging/movies"

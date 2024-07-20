#!/bin/bash

echo "Create Dynamo DB Terraform State Locking"
awslocal dynamodb create-table \
    --table-name terraform-lock-localstack-000000000000-us-east-1 \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo "Create S3 Bucket Terraform Remote State"
awslocal s3api create-bucket \
    --bucket terraform-state-localstack-000000000000-us-east-1
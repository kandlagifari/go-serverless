#!/bin/bash

echo "Create Dynamo DB"
awslocal dynamodb create-table \
    --table-name movies \
    --attribute-definitions AttributeName=ID,AttributeType=S \
    --key-schema AttributeName=ID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo "Scan Initial DynamoDB Items"
awslocal dynamodb scan \
    --table-name movies


# Create API Gateway

```shell
awslocal apigateway create-rest-api \
    --name 'assalamualaikum-api'
```

```shell
awslocal apigateway get-rest-apis
```

```shell
awslocal apigateway get-rest-api \
    --rest-api-id gohjmdpuul
```

```shell
awslocal apigateway get-resources \
    --rest-api-id gohjmdpuul \
    # --query 'items[?path==`/`].id' \
    # --output text
```


# Create Resource

```shell
awslocal apigateway create-resource \
    --rest-api-id gohjmdpuul \
    --parent-id yetvywm8wb \
    --path-part AssalamualaikumServerless \
    # --query 'id' \
    # --output text
```

```shell
awslocal apigateway get-resources \
    --rest-api-id gohjmdpuul
```

```shell
awslocal apigateway get-resource \
    --rest-api-id gohjmdpuul \
    --resource-id jwyc77yj2o
```

# Create Method

```shell
awslocal apigateway put-method \
    --rest-api-id gohjmdpuul \
    --resource-id jwyc77yj2o \
    --http-method ANY \
    --authorization-type "NONE"
```


# Integrate Method with Lambda

```shell
awslocal apigateway put-integration \
    --rest-api-id gohjmdpuul \
    --resource-id jwyc77yj2o \
    --http-method ANY \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:000000000000:function:AssalamualaikumServerless/invocations
```


# Deploy the API

```shell
awslocal apigateway create-deployment \
    --rest-api-id gohjmdpuul \
    --stage-name staging
```


# Test Invoke API 

```shell
http://<apiId>.execute-api.localhost.localstack.cloud:4566/<stageId>/<path>

curl http://75p1kjyzh5.execute-api.localhost.localstack.cloud:4566/staging/AssalamualaikumServerless
```

```shell
http://localhost:4566/restapis/<apiId>/<stageId>/_user_request_/<path>

curl http://localhost:4566/restapis/75p1kjyzh5/staging/_user_request_/AssalamualaikumServerless
```


# Create API Gateway Role

```shell
awslocal iam create-policy \
    --policy-name APIGatewayPushToCloudWatchLogs \
    --policy-document file://iam-policy/apigateway-cw-policy.json
```

```shell
awslocal iam list-policies \
    --query 'Policies[*].[PolicyName, Arn]' \
    --output text | grep -i "APIGatewayPushToCloudWatchLogs"
```

```shell
awslocal iam list-policies \
    --query 'Policies[*].[PolicyName, Arn]' \
    --output text | grep -i "AmazonAPIGatewayPushToCloudWatchLogs"
```

```shell
awslocal iam get-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs
```

```shell
awslocal iam get-policy-version \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs \
    --version-id v1
```

```shell
awslocal iam create-role \
    --role-name APIGatewayPushLogsRole \
    --assume-role-policy-document file://iam-role/apigateway-assume-role.json
```

```shell
awslocal iam list-roles \
    --query 'Roles[*].[RoleName, Arn]' \
    --output text | grep -i "APIGatewayPushLogsRole"
```

```shell
awslocal iam attach-role-policy \
    --policy-arn arn:aws:iam::000000000000:policy/APIGatewayPushToCloudWatchLogs \
    --role-name APIGatewayPushLogsRole
```

```shell
awslocal iam list-attached-role-policies \
    --role-name APIGatewayPushLogsRole
```

```shell
awslocal iam get-role \
    --role-name APIGatewayPushLogsRole \
    --query 'Role.Arn' \
    --output text
```


# Enable execution logging for the stage

```shell
awslocal apigateway update-account \
    --patch-operations op='replace',path='/cloudwatchRoleArn',value="arn:aws:iam::000000000000:role/APIGatewayPushLogsRole"
```

```shell
awslocal apigateway update-stage \
    --rest-api-id hb1goz0llm \
    --stage-name staging \
    --cli-input-json "file://api-logging/api-cw-log-config.json"  
```

```shell
awslocal apigateway update-stage \
    --rest-api-id hb1goz0llm \
    --stage-name staging \
    --patch-operations op=replace,path=/accessLogSettings/destinationArn,value=arn:aws:logs:us-east-1:000000000000:log-group:API-Gateway-Execution-Logs_hb1goz0llm/staging
```

# Enable execution logging for the stage
```shell
awslocal apigateway update-stage \
    --rest-api-id hb1goz0llm \
    --stage-name staging \
    --patch-operations op=replace,path=/accessLogSettings/loggingLevel,value=ERROR
```

```shell
awslocal apigateway get-stage \
    --rest-api-id hb1goz0llm \
    --stage-name staging
```


# Manually create log
```shell
awslocal logs create-log-group \
    --log-group-name /aws/apigateway/hb1goz0llm/accessLogs
```

```shell
awslocal logs describe-log-groups
```

```shell
awslocal logs describe-log-streams \
    --log-group-name /aws/lambda/AssalamualaikumServerless
```

```shell
awslocal logs delete-log-group \
    --log-group-name API-Gateway-Execution-Logs_hb1goz0llm/staging
```

```shell
awslocal logs tail /aws/lambda/AssalamualaikumServerless --follow

awslocal logs tail /aws/apigateway/hb1goz0llm/accessLogs --follow
```


# Invoke Lambda FindAllMovies

```shell
awslocal lambda invoke \
    --function-name FindAllMovies \
    --cli-binary-format raw-in-base64-out \
    --payload '{}' \
    response.json
```


# Invoke Lambda InsertMovie

### With Localstack
```shell
awslocal lambda invoke \
    --function-name InsertMovie \
    --cli-binary-format raw-in-base64-out \
    --payload '{"body": "{\"id\":6,\"name\":\"Sword Art Online\"}"}' \
    response.json
```

### Without Localstack
```shell
awslocal lambda invoke \
    --function-name InsertMovie \
    --cli-binary-format raw-in-base64-out \
    --payload '{"id":6,"name":"Sword Art Online"}' \
    response.json
```

```shell
awslocal logs tail /aws/lambda/InsertMovie --follow
```


# Test API Invoke

```shell
curl -sX GET http://gyxm47qdju.execute-api.localhost.localstack.cloud:4566/staging/movies | jq
```

```shell
curl -sX GET http://gyxm47qdju.execute-api.localhost.localstack.cloud:4566/staging/movies | jq
```

```shell
curl -sX POST -d '{"body": "{\"id\":6,\"name\":\"Sword Art Online\"}"}' http://gyxm47qdju.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX POST -d '{"body": "{\"id\":7,\"name\":\"No Game No Life\"}"}' http://gyxm47qdju.execute-api.localhost.localstack.cloud:4566/staging/movies | jq
```

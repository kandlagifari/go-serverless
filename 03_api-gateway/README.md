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

curl http://gohjmdpuul.execute-api.localhost.localstack.cloud:4566/staging/AssalamualaikumServerless
```

```shell
http://localhost:4566/restapis/<apiId>/<stageId>/_user_request_/<path>

curl http://localhost:4566/restapis/gohjmdpuul/staging/_user_request_/AssalamualaikumServerless
```

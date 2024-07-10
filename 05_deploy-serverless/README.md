# Publish Lambda Version
```shell
awslocal lambda publish-version \
    --function-name FindAllMovies \
    --description 1.0.0
```

```shell
awslocal lambda list-versions-by-function \
    --function-name FindAllMovies \
    --query Versions[*].[Version,Description] \
    --output text
```


# Rebuild and Publish New Lambda
```shell
awslocal s3 cp deployment.zip s3://assalamualaikum-serverless-go-bucket/findAll/deployment.zip
```

```shell
awslocal lambda update-function-code \
    --function-name FindAllMovies \
    --s3-bucket assalamualaikum-serverless-go-bucket \
    --s3-key findAll/deployment.zip
```

```shell
awslocal lambda publish-version \
    --function-name FindAllMovies \
    --description 1.1.0

# We can delete specific lambda version, however it will public the latest incremental number
awslocal lambda delete-function \
    --function-name FindAllMovies:2
```

```shell
awslocal lambda list-versions-by-function \
    --function-name FindAllMovies \
    --query Versions[*].[Version,Description] \
    --output text
```


# Invoke Lambda FindAllMovies
```shell
awslocal lambda invoke \
    --function-name FindAllMovies \
    --cli-binary-format raw-in-base64-out \
    --payload '{}' \
    --qualifier 1 \
    response.json

awslocal lambda invoke \
    --function-name FindAllMovies \
    --cli-binary-format raw-in-base64-out \
    --payload file://input.json \
    --qualifier 3 \
    response.json
```


# Create Lambda Alias
```shell
# Production
awslocal lambda create-alias \
    --function-name FindAllMovies \
    --name Production \
    --description "Production environment" \
    --function-version 1

# Staging
awslocal lambda create-alias \
    --function-name FindAllMovies \
    --name Staging \
    --description "Staging environment" \
    --function-version 3
```


# Invoke Lambda FindAllMovies
```shell
awslocal lambda invoke \
    --function-name FindAllMovies:Production \
    --cli-binary-format raw-in-base64-out \
    --payload '{}' \
    response.json

awslocal lambda invoke \
    --function-name FindAllMovies:Staging \
    --cli-binary-format raw-in-base64-out \
    --payload file://input.json \
    response.json
```


# Create API Gateway Stage Variable
```shell
# Production
awslocal lambda add-permission \
    --function-name "arn:aws:lambda:us-east-1:000000000000:function:FindAllMovies:Production" \
    --source-arn "arn:aws:execute-api:us-east-1:000000000000:q2ugpthj1n/*/GET/movies" \
    --principal apigateway.amazonaws.com \
    --statement-id InvokeLambdaAPI \
    --action lambda:InvokeFunction

# Staging
awslocal lambda add-permission \
    --function-name "arn:aws:lambda:us-east-1:000000000000:function:FindAllMovies:Staging" \
    --source-arn "arn:aws:execute-api:us-east-1:000000000000:q2ugpthj1n/*/GET/movies" \
    --principal apigateway.amazonaws.com \
    --statement-id InvokeLambdaAPI \
    --action lambda:InvokeFunction
```


# Create New Stage for Production
```shell
awslocal apigateway create-deployment \
    --rest-api-id q2ugpthj1n \
    --stage-name production
```

```shell
awslocal apigateway get-stages \
    --rest-api-id q2ugpthj1n
```


# Create Stage Variable
> **_NOTE:_** Currently not supported on the Local Stack

```shell
# Production
awslocal apigateway update-stage \
    --rest-api-id q2ugpthj1n \
    --stage-name production \
    --patch-operations op="replace",path=/variables/lambda,value="FindAllMovies:Production"

# Staging
awslocal apigateway update-stage \
    --rest-api-id q2ugpthj1n \
    --stage-name staging \
    --patch-operations op="replace",path=/variables/lambda,value="FindAllMovies:Staging"
```

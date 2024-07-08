# Create Dynamo DB

```shell
awslocal dynamodb create-table \
    --table-name movies \
    --attribute-definitions AttributeName=ID,AttributeType=S \
    --key-schema AttributeName=ID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

```shell
awslocal dynamodb scan \
    --table-name movies
```

# Invoke Lambda FindAllMovies

```shell
awslocal lambda invoke \
    --function-name FindAllMovies \
    --cli-binary-format raw-in-base64-out \
    --payload '{}' \
    response.json
```


# Test API findAll

```shell
curl -sX GET http://nocjbsl9m0.execute-api.localhost.localstack.cloud:4566/staging/movies | jq '.'
```

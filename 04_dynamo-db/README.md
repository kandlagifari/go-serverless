> **_IMPORTANT NOTE:_** Make sure to run always run `init_db.go` whenever creating new localstack environment (via docker compose)

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


# Invoke Lambda InsertMovie

### With Localstack
```shell
awslocal lambda invoke \
    --function-name InsertMovie \
    --cli-binary-format raw-in-base64-out \
    --payload '{"body": "{\"id\":\"16\",\"name\":\"Sword Art Online\"}"}' \
    response.json
```

### Without Localstack
```shell
awslocal lambda invoke \
    --function-name InsertMovie \
    --cli-binary-format raw-in-base64-out \
    --payload '{"id":"16","name":"Sword Art Online"}' \
    response.json
```


# Test API Gateway

```shell
curl -sX GET http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq '.'
```

```shell
curl -sX GET http://localhost:4566/restapis/v7oc56givg/staging/_user_request_/movies | jq '.'
```

```shell
curl -sX GET http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies/16 | jq '.'
```

```shell
curl -sX POST -d '{"id":"16","name":"Sword Art Online"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX POST -d '{"body": "{\"id\":\"16\",\"name\":\"Sword Art Online\"}"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX POST -d '{"body": "{\"id\":\"17\",\"name\":\"No Game No Life\"}"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq
```

```shell
curl -sX DELETE -d '{"id":"16","name":"Sword Art Online"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX DELETE -d '{"body": "{\"id\":\"16\",\"name\":\"Sword Art Online\"}"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX DELETE -d '{"body": "{\"id\":\"16\"}"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq

curl -sX DELETE -d '{"body": "{\"id\":\"17\",\"name\":\"No Game No Life\"}"}' http://v7oc56givg.execute-api.localhost.localstack.cloud:4566/staging/movies | jq
```
# Create S3 Bucket

```shell
awslocal s3api create-bucket \
    --bucket assalamualaikum-serverless-go-bucket
```


# Create IAM Policy

```shell
awslocal iam create-policy \
    --policy-name PushLogsToCloudWatch \
    --policy-document file://iam-policy/lambda-cw-policy.json
```

```shell
awslocal iam list-policies \
    --query 'Policies[*].[PolicyName, Arn]' \
    --output text | grep -i "PushLogsToCloudWatch"
```

```shell
awslocal iam get-policy \
    --policy-arn arn:aws:iam::000000000000:policy/PushLogsToCloudWatch
```

```shell
awslocal iam get-policy-version \
    --policy-arn arn:aws:iam::000000000000:policy/PushLogsToCloudWatch \
    --version-id v1
```


# Create IAM Role

```shell
awslocal iam create-role \
    --role-name AssalamualaikumServerlessRole \
    --assume-role-policy-document file://iam-role/lambda-assume-role.json
```

```shell
awslocal iam list-roles \
    --query 'Roles[*].[RoleName, Arn]' \
    --output text | grep -i "AssalamualaikumServerlessRole"
```

```shell
awslocal iam attach-role-policy \
    --policy-arn arn:aws:iam::000000000000:policy/PushLogsToCloudWatch \
    --role-name AssalamualaikumServerlessRole
```

```shell
awslocal iam list-attached-role-policies \
    --role-name AssalamualaikumServerlessRole
```


# Copy zip to S3

```shell
awslocal s3 cp deployment.zip s3://assalamualaikum-serverless-go-bucket
```

```shell
awslocal s3 ls s3://assalamualaikum-serverless-go-bucket
```


# Create Lambda

```shell
awslocal lambda create-function \
    --function-name AssalamualaikumServerless \
    --runtime provided.al2023 \
    --handler bootstrap \
    --role arn:aws:iam::000000000000:role/AssalamualaikumServerlessRole \
    --code S3Bucket=assalamualaikum-serverless-go-bucket,S3Key=deployment.zip
```

```shell
awslocal lambda list-functions \
    --output table
```

```shell
awslocal lambda get-function \
    --function-name  AssalamualaikumServerless
```

```shell
awslocal lambda update-function-configuration \
    --function-name  AssalamualaikumServerless \
    --timeout 60
```

```shell
awslocal lambda invoke \
    --function-name AssalamualaikumServerless \
    --cli-binary-format raw-in-base64-out \
    --payload '{}' \
    response.json
```

```shell
awslocal lambda invoke \
    --function-name AssalamualaikumServerless response-2.json \
    --log-type Tail \
    --query "LogResult"
```

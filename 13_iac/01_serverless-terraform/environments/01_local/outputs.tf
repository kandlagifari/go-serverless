output "api_endpoint_local" {
  value = "http://${aws_api_gateway_rest_api.api.id}.execute-api.localhost.localstack.cloud:4566/local/movies"
}

output "api_endpoint_remote" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_rest_api.api.id}/local/_user_request_/movies"
}

output "s3_website_endpoint" {
  value = "http://localhost:4566/${module.local_s3_website.s3_bucket_name["assalamualaikumserverless"]}/index.html"
}

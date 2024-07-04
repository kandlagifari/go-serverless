// Solution 1 //
// package main

// import "github.com/aws/aws-lambda-go/lambda"

// type Response struct {
// 	StatusCode int    `json:"statusCode"`
// 	Body       string `json:"body"`
// }

// func handler() (Response, error) {
// 	return Response{
// 		StatusCode: 200,
// 		Body:       "Assalamualaikum from Golang Serverless",
// 	}, nil
// }

// func main() {
// 	lambda.Start(handler)
// }

// Solution 2 //
package main

import (
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler() (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       "Assalamualaikum from Golang Serverless",
	}, nil
}

func main() {
	lambda.Start(handler)
}

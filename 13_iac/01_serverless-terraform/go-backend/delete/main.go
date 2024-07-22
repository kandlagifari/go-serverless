package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type Movie struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Cover       string `json:"cover"`
	Description string `json:"description"`
}

func delete(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Printf("Received request: %+v", request)
	log.Printf("Request body: %s", request.Body)

	// Decode URL-encoded request body
	decodedBody, err := url.QueryUnescape(request.Body)
	if err != nil {
		log.Printf("Error decoding request body: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Invalid payload",
		}, nil
	}

	log.Printf("Decoded request body: %s", decodedBody)

	cleanedBody := strings.ReplaceAll(decodedBody, "=", "")
	log.Printf("Cleaned decoded request body: %s", cleanedBody)

	// Unmarshal the decoded body into a map
	var requestBody map[string]string
	err = json.Unmarshal([]byte(cleanedBody), &requestBody)
	if err != nil {
		log.Printf("Error unmarshalling request body: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Invalid payload",
		}, nil
	}

	// Extract the inner JSON string from the "body" field
	innerJSON := requestBody["body"]

	log.Printf("Inner JSON string: %s", innerJSON)

	// Unmarshal the inner JSON string into a Movie struct
	var movie Movie
	err = json.Unmarshal([]byte(innerJSON), &movie)
	if err != nil {
		log.Printf("Error unmarshalling inner JSON: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Invalid payload",
		}, nil
	}

	log.Printf("Received movie to delete: %+v", movie)

	// Load AWS configuration
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"),
		config.WithEndpointResolver(aws.EndpointResolverFunc(
			func(service, region string) (aws.Endpoint, error) {
				if service == dynamodb.ServiceID && region == "us-east-1" {
					return aws.Endpoint{
						URL:           "http://localstack:4566", // LocalStack endpoint
						SigningRegion: "us-east-1",
					}, nil
				}
				return aws.Endpoint{}, &aws.EndpointNotFoundError{}
			}),
		),
	)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       fmt.Sprintf("Error while retrieving AWS credentials: %v", err),
		}, nil
	}

	// Create DynamoDB client
	svc := dynamodb.NewFromConfig(cfg)
	input := &dynamodb.DeleteItemInput{
		TableName: aws.String(os.Getenv("TABLE_NAME")),
		Key: map[string]types.AttributeValue{
			"ID": &types.AttributeValueMemberS{Value: movie.ID},
		},
	}

	// DeleteItem request to DynamoDB
	_, err = svc.DeleteItem(context.TODO(), input)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while deleting movie from DynamoDB",
		}, nil
	}

	// Return successful response
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}

func main() {
	lambda.Start(delete)
}

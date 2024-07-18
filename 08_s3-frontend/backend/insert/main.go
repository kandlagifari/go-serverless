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
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/google/uuid"
)

type Movie struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Cover       string `json:"cover"`
	Description string `json:"description"`
}

func insert(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
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

	// Unmarshal the inner JSON string into a Movie struct
	var movie Movie
	err = json.Unmarshal([]byte(requestBody["body"]), &movie)
	if err != nil {
		log.Printf("Error unmarshalling inner JSON: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusBadRequest,
			Body:       "Invalid payload",
		}, nil
	}

	// Generate a unique ID for the movie
	movie.ID = uuid.New().String()
	log.Printf("Generated ID for movie: %s", movie.ID)

	log.Printf("Received movie to insert: %+v", movie)

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

	// Marshal Movie struct into AttributeValue map
	av, err := attributevalue.MarshalMap(movie)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error marshalling movie into DynamoDB format",
		}, fmt.Errorf("error marshalling movie into DynamoDB format: %v", err)
	}

	// Prepare PutItemInput
	input := &dynamodb.PutItemInput{
		TableName: aws.String(os.Getenv("TABLE_NAME")),
		Item:      av,
	}

	// PutItem request to DynamoDB
	_, err = svc.PutItem(context.TODO(), input)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while inserting movie to DynamoDB",
		}, fmt.Errorf("error inserting movie to DynamoDB: %v", err)
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
	lambda.Start(insert)
}

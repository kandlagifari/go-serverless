package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Movie struct {
	ID          string
	Name        string
	Cover       string
	Description string
}

func main() {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion("us-east-1"), // or the region of your choice
		config.WithEndpointResolver(aws.EndpointResolverFunc(
			func(service, region string) (aws.Endpoint, error) {
				if service == dynamodb.ServiceID {
					return aws.Endpoint{
						PartitionID:   "aws",
						URL:           "http://localhost:4566", // LocalStack endpoint
						SigningRegion: "us-east-1",
					}, nil
				}
				return aws.Endpoint{}, fmt.Errorf("unknown endpoint requested")
			}),
		),
	)
	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
	}

	movies, err := readMovies("movies.json")
	if err != nil {
		log.Fatalf("failed to read movies, %v", err)
	}

	for _, movie := range movies {
		fmt.Println("Inserting:", movie.Name)
		err = insertMovie(cfg, movie)
		if err != nil {
			log.Fatalf("failed to insert movie %s, %v", movie.Name, err)
		}
	}
}

func readMovies(fileName string) ([]Movie, error) {
	movies := make([]Movie, 0)

	data, err := os.ReadFile(fileName)
	if err != nil {
		return movies, fmt.Errorf("failed to read file %s, %w", fileName, err)
	}

	err = json.Unmarshal(data, &movies)
	if err != nil {
		return movies, fmt.Errorf("failed to unmarshal JSON, %w", err)
	}

	return movies, nil
}

func insertMovie(cfg aws.Config, movie Movie) error {
	item, err := attributevalue.MarshalMap(movie)
	if err != nil {
		return fmt.Errorf("failed to marshal movie, %w", err)
	}

	svc := dynamodb.NewFromConfig(cfg)
	_, err = svc.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String("movies"),
		Item:      item,
	})
	if err != nil {
		return fmt.Errorf("failed to put item in DynamoDB, %w", err)
	}
	return nil
}

package main

import (
	"encoding/json"
	"log"
	"net/http"
	"net/url"
	"strings"
	"sync"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Movie struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

var (
	movies = []Movie{
		{
			ID:   1,
			Name: "Avengers",
		},
		{
			ID:   2,
			Name: "Ant-Man",
		},
		{
			ID:   3,
			Name: "Thor",
		},
		{
			ID:   4,
			Name: "Hulk",
		},
		{
			ID:   5,
			Name: "Doctor Strange",
		},
	}
	moviesMu sync.Mutex
)

func insert(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Printf("Received request: %+v", req)
	log.Printf("Request body: %s", req.Body)

	// Decode URL-encoded request body
	decodedBody, err := url.QueryUnescape(req.Body)
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

	log.Printf("Received movie to insert: %+v", movie)

	// Ensure the movie ID is unique
	moviesMu.Lock()
	defer moviesMu.Unlock()
	for _, m := range movies {
		if m.ID == movie.ID {
			log.Printf("Movie ID already exists: %d", movie.ID)
			return events.APIGatewayProxyResponse{
				StatusCode: http.StatusConflict,
				Body:       "Movie ID already exists",
			}, nil
		}
	}

	// Example: Append the new movie to the movies array
	movies = append(movies, movie)

	// Prepare the response body with updated movies array
	responseBody, err := json.Marshal(movies)
	if err != nil {
		log.Printf("Error marshalling response: %v", err)
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       err.Error(),
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(responseBody),
	}, nil
}

func main() {
	lambda.Start(insert)
}

// // For Debugging (Run Locally)
// func insert(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
// 	log.Printf("Received request: %+v", req)
// 	log.Printf("Request body: %s", req.Body)

// 	var movie Movie
// 	err := json.Unmarshal([]byte(req.Body), &movie)
// 	if err != nil {
// 		log.Printf("Error unmarshalling request: %v", err)
// 		return events.APIGatewayProxyResponse{
// 			StatusCode: http.StatusBadRequest,
// 			Body:       "Invalid payload",
// 		}, nil
// 	}

// 	log.Printf("Successfully unmarshalled movie: %+v", movie)

// 	return events.APIGatewayProxyResponse{
// 		StatusCode: http.StatusOK,
// 		Body:       "Payload is valid",
// 	}, nil
// }

// func main() {
// 	req := events.APIGatewayProxyRequest{
// 		Body: `{"id":6,"name":"Sword Art Online"}`,
// 	}
// 	resp, err := insert(req)
// 	if err != nil {
// 		log.Fatalf("Handler error: %v", err)
// 	}
// 	log.Printf("Response: %+v", resp)
// }

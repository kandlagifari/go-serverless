package main

import (
	"net/http"
	"testing"

	"github.com/aws/aws-lambda-go/events"
	"github.com/stretchr/testify/assert"
)

func TestInsert_InvalidPayLoad(t *testing.T) {
	input := events.APIGatewayProxyRequest{
		Body: "{'name': 'Sword Art Online'}",
	}
	expected := events.APIGatewayProxyResponse{
		StatusCode: http.StatusBadRequest,
		Body:       "Invalid payload",
	}
	response, _ := insert(input)
	assert.Equal(t, expected, response)
}

func TestInsert_ValidPayload(t *testing.T) {
	input := events.APIGatewayProxyRequest{
		Body: `{"body": "{\"id\":\"16\",\"name\":\"Sword Art Online\",\"cover\" : \"https://cdn.myanimelist.net/images/anime/11/39717.jpg\",\"description\" : \"Isekai\"}"}`,
	}
	expected := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type":                "application/json",
			"Access-Control-Allow-Origin": "*",
		},
	}
	response, _ := insert(input)
	assert.Equal(t, expected, response)
}

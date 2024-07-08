#!/bin/bash

echo "Build the binary"
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go

echo "Create a ZIP file"
zip deployment.zip bootstrap

echo "Cleaning up"
rm bootstrap

test-find-all:
	@cd findAll && \
	pwd && \
	TABLE_NAME=movies go test -cover -coverprofile=coverage.out && \
	go tool cover -html=coverage.out -o coverage.html

test-insert:
	@cd insert && \
	pwd && \
	TABLE_NAME=movies go test -cover -coverprofile=coverage.out && \
	go tool cover -html=coverage.out -o coverage.html

test-serverless:
	@cd findAll && \
	pwd && \
	TABLE_NAME=movies go test -cover -coverprofile=coverage.out && \
	go tool cover -html=coverage.out -o coverage.html
	@cd insert && \
	pwd && \
	TABLE_NAME=movies go test -cover -coverprofile=coverage.out && \
	go tool cover -html=coverage.out -o coverage.html

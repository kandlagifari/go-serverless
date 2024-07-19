# Basic Command
```shell
TABLE_NAME=movies go test
```

# Coverage Mode
```shell
TABLE_NAME=movies go test -cover
```

# Generate HTML Coverage Report
```shell
TABLE_NAME=movies go test -cover -coverprofile=coverage.out
go tool cover -html=coverage.out -o coverage.html
```
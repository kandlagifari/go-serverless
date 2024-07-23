build-backend:
	@cd backend/findAll && pwd && ./build.sh
	@cd backend/findOne && pwd && ./build.sh
	@cd backend/insert && pwd && ./build.sh
	@cd backend/delete && pwd && ./build.sh

build-find-all:
	@cd backend/findAll && pwd && ./build.sh

build-find-one:
	@cd backend/findOne && pwd && ./build.sh

build-insert:
	@cd backend/insert && pwd && ./build.sh

build-delete:
	@cd backend/delete && pwd && ./build.sh

init-db:
	@cd 00_config/init-db && pwd && go run init-db.go

run-frontend:
	@cd frontend && pwd && ng serve --host 0.0.0.0

build-frontend:
	@cd frontend && ng build --configuration production

run-s3-site:
	@cd frontend && awslocal s3 cp --recursive dist/frontend/browser/ s3://assalamualaikumserverless.cloud/
	@awslocal s3 ls s3://assalamualaikumserverless.cloud/
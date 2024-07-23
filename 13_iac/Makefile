build-backend:
	@cd 01_serverless-terraform/go-backend/findAll && pwd && ./build.sh
	@cd 01_serverless-terraform/go-backend/findOne && pwd && ./build.sh
	@cd 01_serverless-terraform/go-backend/insert && pwd && ./build.sh
	@cd 01_serverless-terraform/go-backend/delete && pwd && ./build.sh

build-find-all:
	@cd 01_serverless-terraform/go-backend/findAll && pwd && ./build.sh

build-find-one:
	@cd 01_serverless-terraform/go-backend/findOne && pwd && ./build.sh

build-insert:
	@cd 01_serverless-terraform/go-backend/insert && pwd && ./build.sh

build-delete:
	@cd 01_serverless-terraform/go-backend/delete && pwd && ./build.sh

tfl-all:
	@cd 01_serverless-terraform && pwd
	@cd 01_serverless-terraform && tflocal fmt -recursive

tfi-local:
	@cd 01_serverless-terraform/environments/01_local && pwd
	@cd 01_serverless-terraform/environments/01_local && tflocal init

tfp-local:
	@cd 01_serverless-terraform/environments/01_local && pwd
	@cd 01_serverless-terraform/environments/01_local && tflocal plan

tfa-local:
	@cd 01_serverless-terraform/environments/01_local && pwd
	@cd 01_serverless-terraform/environments/01_local && tflocal apply

tfd-local:
	@cd 01_serverless-terraform/environments/01_local && pwd
	@cd 01_serverless-terraform/environments/01_local && tflocal destroy

tfs-local:
	@cd 01_serverless-terraform/environments/01_local && pwd
	@cd 01_serverless-terraform/environments/01_local && tflocal state list

init-db:
	@cd 01_serverless-terraform/init-db && pwd && go run init-db.go

run-frontend:
	@cd 01_serverless-terraform/angular-frontend && pwd && ng serve --host 0.0.0.0

build-frontend:
	@cd 01_serverless-terraform/angular-frontend && ng build --configuration production

run-s3-site:
	@cd 01_serverless-terraform/angular-frontend && awslocal s3 cp --recursive dist/frontend/browser/ s3://assalamualaikumserverless.cloud/
	@awslocal s3 ls s3://assalamualaikumserverless.cloud/

empty-bucket:
	awslocal s3api delete-objects \
	--bucket assalamualaikumserverless.cloud \
	--delete "$$(awslocal s3api list-object-versions \
	--bucket assalamualaikumserverless.cloud \
	--output=json \
	--query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

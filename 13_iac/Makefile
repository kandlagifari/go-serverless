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
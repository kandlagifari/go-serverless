tfl-all:
	@cd 01_serverless-terraform && pwd
	@cd 01_serverless-terraform && tflocal fmt -recursive

tfi-staging:
	@cd 01_serverless-terraform/environments/staging && pwd
	@cd 01_serverless-terraform/environments/staging && tflocal init

tfp-staging:
	@cd 01_serverless-terraform/environments/staging && pwd
	@cd 01_serverless-terraform/environments/staging && tflocal plan

tfa-staging:
	@cd 01_serverless-terraform/environments/staging && pwd
	@cd 01_serverless-terraform/environments/staging && tflocal apply

tfd-staging:
	@cd 01_serverless-terraform/environments/staging && pwd
	@cd 01_serverless-terraform/environments/staging && tflocal destroy

tfs-staging:
	@cd 01_serverless-terraform/environments/staging && pwd
	@cd 01_serverless-terraform/environments/staging && tflocal state list
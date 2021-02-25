# Default environment
ENV := dev
ENV_FILE := $(ENV).env

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: install-deps
install-deps: ## Install required dependencies
	./scripts/setup_env.sh

.PONY: wallet
wallet: ## Get the Database wallet
	. $(ENV_FILE); \
	export WALLET_PWD=`printf $$(xxd -l 14 -p /dev/urandom | tr 'acegikmoqsuwy' 'ACEGIKMOQSUWY')`; \
	oci db autonomous-database generate-wallet --autonomous-database-id $${DB_OCID} --file $(ENV)-wallet.zip --password "$${WALLET_PWD}"

.PHONY: sql
sql: ## SQLcl shell as APEX ADMIN user
	. $(ENV_FILE); \
	echo $$APEX_ADMIN_EMAIL; \
	echo $$WALLET_FILE; \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} 

.PHONY: create-apex-admin
create-apex-admin: ## Create the APEX admin user
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${DB_ADMIN_USER}/$${DB_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/create_apex_admin.sql "$${APEX_ADMIN_USER}" "$${APEX_ADMIN_PWD}" EOF

.PHONY: delete-apex-admin
delete-apex-admin: ## Delete the APEX admin user
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${DB_ADMIN_USER}/$${DB_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/remove_apex_admin.sql "$${APEX_ADMIN_USER}" EOF

.PHONY: create-cloud-creds
create-cloud-creds: ## Create default cloud credential for the APEX ADMIN user to use datapump to Object Storage 
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${DB_ADMIN_USER}/$${DB_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/create_cloud_credentials.sql "$${APEX_ADMIN_EMAIL}" "$${APEX_ADMIN_TOKEN}" EOF

.PHONY: create-schema
create-schema: ## Create schema
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/create_schema.sql "$${SCHEMA}" "$${SCHEMA_ADMIN_PWD}" EOF

.PHONY: delete-schema
delete-schema: ## Delete schema
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/remove_schema.sql "$${SCHEMA}" EOF

.PHONY: create-ws
create-ws: create-schema ## Create schema, workspace, add schema to workspace and create workspace admin user
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/create_workspace.sql "$${SCHEMA}" "$${APEX_ADMIN_USER}" "$${WORKSPACE_ADMIN}" "$${WORKSPACE_ADMIN_PWD}" "$${WORKSPACE_ADMIN_EMAIL}" "$${WORKSPACE_NAME}" EOF

.PHONY: delete-ws
delete-ws: ## Delete workspace and its users
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/admin/remove_workspace.sql "$${WORKSPACE_NAME}" "$${WORKSPACE_ADMIN}" EOF

.PHONY: export-app
export-app: ## Export the Apex App. Specify ID=<app_id>
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${SCHEMA}/$${SCHEMA_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/change_tracking/export_app.sql $(ID) EOF

.PHONY: import-app
import-app: ## Import the Apex App. Specify ID=<app_id>
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${SCHEMA}/$${SCHEMA_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/change_tracking/apex_install_overrides.sql "$${WORKSPACE_NAME}" "$${SCHEMA}" $(ID) $(NEWID) "apps/f$(ID).sql" EOF; \

.PHONY: changelog
changelog: ## Generate a new Change Log for the schema
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${SCHEMA}/$${SCHEMA_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/change_tracking/gen_schema.sql EOF

.PHONY: update-schema
update-schema: ## Apply the Change Log to the schema
	. $(ENV_FILE); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	sql -cloudconfig $${WALLET_FILE} $${SCHEMA}/$${SCHEMA_ADMIN_PWD}@$${DB_SERVICE} << EOF @./scripts/sql/change_tracking/apply_changelog.sql EOF

.PHONY: snapshot
snapshot: changelog export-app ## Create a new change Log, and export the app. Specify ID=<app_id>

.PHONY: update
update: update-schema import-app ## Apply the Change Log to the schema and import the app. Specify ID=<app_id> NEWID=<new_app_id>

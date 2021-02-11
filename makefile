# Default environment
ENV := ./dev.env

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

.PHONY: create-apex-admin
create-apex-admin: ## Create the APEX admin user
	. $(ENV); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	export TNS_ADMIN=$(PWD)/$${WALLET_PATH}; \
	sql admin/$${DB_ADMIN_PWD}@$${DB_SERVICE} << EOF @./admin/scripts/create_apex_admin.sql "$${APEX_ADMIN_USER}" "$${APEX_ADMIN_PWD}" "$${APEX_ADMIN_EMAIL}" "$${APEX_ADMIN_TOKEN}" EOF

.PHONY: delete-apex-admin
delete-apex-admin: ## Delete the APEX admin user
	. $(ENV); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	export TNS_ADMIN=$(PWD)/$${WALLET_PATH}; \
	sql admin/$${DB_ADMIN_PWD}@$${DB_SERVICE} << EOF @./admin/scripts/remove_apex_admin.sql "$${APEX_ADMIN_USER}" EOF

.PHONY: create-ws
create-ws: ## Create workspace, schema and workspace admin user
	. $(ENV); \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	export TNS_ADMIN=$(PWD)/$${WALLET_PATH}; \
	sql $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./admin/scripts/create_workshop_user.sql "$${SCHEMA}" "$${SCHEMA_ADMIN_PWD}" "$${WORKSPACE_ADMIN}" "$${WORKSPACE_ADMIN_PWD}" "$${WORKSPACE_ADMIN_EMAIL}" "$${WORKSPACE_NAME}" "$${APEX_ADMIN_USER}" EOF

.PHONY: delete-ws
delete-ws: ## Delete workspace, schema and user
	. $(ENV); \
	echo $$APEX_ADMIN_EMAIL; \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	export TNS_ADMIN=$(PWD)/$${WALLET_PATH}; \
	sql $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF @./admin/scripts/remove_workshop_user.sql "$${SCHEMA}" "$${WORKSPACE_ADMIN}" "$${WORKSPACE_NAME}" EOF

.PHONY: test
test: ## Test connection
	. $(ENV); \
	echo $$APEX_ADMIN_EMAIL; \
	export PATH=$$PATH:$(PWD)/sqlcl/bin/; \
	export TNS_ADMIN=$(PWD)/$${WALLET_PATH}; \
	sql $${APEX_ADMIN_USER}/$${APEX_ADMIN_PWD}@$${DB_SERVICE} << EOF exit; EOF
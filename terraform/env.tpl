## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# wallet file name
ENV_NAME=$(echo $${BASH_SOURCE[0]} | awk -F"." '{print $1}')
WALLET_FILE=$${ENV_NAME}-wallet.zip
DB_OCID=${db_ocid}

# DB admin
DB_NAME=${db_name}
DB_SERVICE=$${DB_NAME}_tp
DB_ADMIN_USER=admin
DB_ADMIN_PWD="P${admin_password}"

# APEX Admin User
APEX_ADMIN_USER=apexadmin
APEX_ADMIN_PWD="P${apex_admin_password}"
APEX_ADMIN_EMAIL=${apex_admin_email}
APEX_ADMIN_TOKEN=""

# Schema
SCHEMA=${schema_name}
SCHEMA_ADMIN_PWD="P${schema_password}"

# Workspace
WORKSPACE_ADMIN=${ws_admin}
WORKSPACE_ADMIN_PWD="P${ws_admin_password}"
WORKSPACE_ADMIN_EMAIL=${ws_admin_email}
WORKSPACE_NAME=${workspace_name}
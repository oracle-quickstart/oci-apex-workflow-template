. ./dev.env

ORIGINAL_SCHEMA_USER=$(cat development/apex/f*.sql | grep "Exported By" | awk '{print $4}')
echo "SCHEMA: ${ORIGINAL_SCHEMA_USER}"

NEW_SCHEMA=$(echo ${SCHEMA} | tr 'a-z' 'A-Z')

# replace the old SCHEMA name with new schema if the app was exported from somewhere else
sed -i '' -e "s/'${ORIGINAL_SCHEMA_USER}'/'${NEW_SCHEMA}'/g;" development/apex/f*.sql
sed -i '' -e "s/Exported By:     ${ORIGINAL_SCHEMA_USER}/Exported By:     ${NEW_SCHEMA}/g;" development/apex/f*.sql

export PATH=$PATH:$(PWD)/sqlcl/bin/
export TNS_ADMIN=$(PWD)/${WALLET_PATH}

# cat > deploy_app.sql << EOQ
# lb update -changelog ./development/changelogs/change_create_apex.xml
# EOQ

# sql ${APEX_ADMIN_USER}/${APEX_ADMIN_PWD}@${DB_SERVICE} << EOF
# @deploy_app.sql \
# "${WORKSPACE_NAME}" \
# "${SCHEMA}"
# EOF

# sql ${APEX_ADMIN_USER}/${APEX_ADMIN_PWD}@${DB_SERVICE} << EOF

# EOF

WORKSPACE_NAME_UPPER=$(echo ${WORKSPACE_NAME} | tr 'a-z' 'A-Z')
sql ${APEX_ADMIN_USER}/${APEX_ADMIN_PWD}@${DB_SERVICE} << EOF
@development/scripts/set_workspace.sql \
"${WORKSPACE_NAME_UPPER}" \
"${NEW_SCHEMA}" \
EOF

sql ${APEX_ADMIN_USER}/${APEX_ADMIN_PWD}@${DB_SERVICE} << EOF
@development/apex/f100.sql
EOF


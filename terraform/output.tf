## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
    all_envs = tolist(flatten(var.databases.*.envs))
    # db_idx_map = merge([for db in var.databases: {for env in db.envs: env => index(var.databases, db) }])
    db_idx_map = flatten([for env in local.all_envs: index([for db in var.databases: contains(db.envs, env)], true)])

}

resource "local_file" "env" {
    count = length(local.all_envs)
    filename = "../${local.all_envs[count.index]}.env"
    content = templatefile("env.tpl", {
        db_name = oci_database_autonomous_database.atp[local.db_idx_map[count.index]].db_name
        db_ocid = oci_database_autonomous_database.atp[local.db_idx_map[count.index]].id
        admin_password = random_password.admin_password[local.db_idx_map[count.index]].result
        apex_admin_password = random_password.apex_admin_password[local.db_idx_map[count.index]].result
        apex_admin_email = var.environments[local.all_envs[count.index]].apex_admin_email
        schema_name = var.environments[local.all_envs[count.index]].schema_name
        schema_password = random_password.schema_password[count.index].result
        ws_admin = var.environments[local.all_envs[count.index]].workspace_admin
        ws_admin_password = random_password.ws_admin_password[count.index].result
        ws_admin_email = var.environments[local.all_envs[count.index]].ws_admin_email
        workspace_name = var.environments[local.all_envs[count.index]].workspace_name
        ws_password = random_password.ws_password[count.index].result
    })
}
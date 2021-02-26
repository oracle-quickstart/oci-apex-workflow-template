## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_database_autonomous_database" "atp" {
    count = length(var.databases)
    #Required
    compartment_id = var.compartment_id
    cpu_core_count = var.databases[count.index].cpu_core_count
    db_name = var.databases[count.index].db_name

    #Optional
    admin_password = "P${random_password.admin_password[count.index].result}"
    data_storage_size_in_tbs = var.databases[count.index].storage_size_in_tbs
    db_version = var.databases[count.index].db_version
    db_workload = var.databases[count.index].db_workload
    display_name = var.databases[count.index].display_name
    is_auto_scaling_enabled = var.databases[count.index].is_free_tier ? false : true
    is_free_tier = var.databases[count.index].is_free_tier
    license_model = var.databases[count.index].license_model
}
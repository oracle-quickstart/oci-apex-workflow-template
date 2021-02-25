resource "oci_database_autonomous_database" "atp" {
    #Required
    compartment_id = var.compartment_id
    cpu_core_count = var.autonomous_database_cpu_core_count
    db_name = var.autonomous_database_db_name

    #Optional
    admin_password = random_password.admin_password.result
    data_storage_size_in_tbs = var.autonomous_database_data_storage_size_in_tbs
    db_version = "19c"
    db_workload = "OLTP"
    display_name = var.autonomous_database_display_name
    is_auto_scaling_enabled = var.autonomous_database_is_free_tier ? false : true
    is_free_tier = var.autonomous_database_is_free_tier
    license_model = "LICENSE_INCLUDED"
}
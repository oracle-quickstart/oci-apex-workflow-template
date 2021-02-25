output "DB_admin_password" {
    value = random_password.admin_password.result
}
output "DB_ocid" {
    value = oci_database_autonomous_database.atp.id
}

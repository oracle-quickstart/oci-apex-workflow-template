variable "region" {}
variable "compartment_id" {}
variable "autonomous_database_cpu_core_count" {
    default = 1
}
variable "autonomous_database_db_name" {}
variable "autonomous_database_data_storage_size_in_tbs" {
    default = 1
}
variable "autonomous_database_display_name" {}
variable "autonomous_database_is_free_tier" {
    default = true
}
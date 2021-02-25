resource "random_password" "admin_password" {
  length           = 28
  special          = true
  override_special = "#!="
}
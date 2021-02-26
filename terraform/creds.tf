resource "random_password" "admin_password" {
    count = length(var.databases)
    length           = 28
    special          = true
    min_special      = 1
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1 
    override_special = "#"
}

resource "random_password" "apex_admin_password" {
    count = length(var.databases)
    length           = 28
    special          = true
    min_special      = 1
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1 
    override_special = "#"
}

resource "random_password" "schema_password" {
    count = length(keys(var.environments))
    length           = 28
    special          = true
    min_special      = 1
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1 
    override_special = "#"
}

resource "random_password" "ws_password" {
    count = length(keys(var.environments))
    length           = 28
    special          = true
    min_special      = 1
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1 
    override_special = "#"
}

resource "random_password" "ws_admin_password" {
    count = length(keys(var.environments))
    length           = 28
    special          = true
    min_special      = 1
    min_upper        = 1
    min_lower        = 1
    min_numeric      = 1 
    override_special = "#"
}
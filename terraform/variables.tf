variable "region" {}
variable "compartment_id" {}
variable "databases" {
    default = []
}
variable "environments" { 
    default = {
        "dev" = {
            workspace_name = "WS"
            schema_name = "MYAPP"
        }
    }
}

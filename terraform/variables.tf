## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

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

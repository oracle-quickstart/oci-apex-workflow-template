## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

provider "oci" {
  version              = ">= 4.6.0"
  region               = var.region
  disable_auto_retries = "true"
}

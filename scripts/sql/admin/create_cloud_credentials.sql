-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

DECLARE
   l_oci_username VARCHAR2(100) := '&1';
   l_oci_authtoken VARCHAR2(100) := '&2';
BEGIN
    dbms_cloud.create_credential(
            credential_name => 'DEF_CRED_NAME',
            username => l_oci_username,
            password => l_oci_authtoken
    );
    EXCEPTION
        WHEN others THEN
          null;
END;
/
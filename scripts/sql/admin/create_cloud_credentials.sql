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
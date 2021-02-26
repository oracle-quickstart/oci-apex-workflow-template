-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

declare
   l_schema VARCHAR2(30) := '&1';
   l_schema_password VARCHAR2(30) := '&2';

begin
    execute immediate 'create user ' || l_schema || ' identified by ' || l_schema_password || ' default tablespace DATA quota unlimited on DATA';
    execute immediate 'grant connect to ' || l_schema;
    execute immediate 'grant resource to ' || l_schema;
    execute immediate 'grant dwrole to ' || l_schema;
    execute immediate 'grant create session to ' || l_schema;

    begin
        for c1 in (select privilege
                   from sys.dba_sys_privs
                   where grantee = 'APEX_GRANTS_FOR_NEW_USERS_ROLE') loop
                execute immediate 'grant ' || c1.privilege || ' to ' || l_schema ;
        end loop;
    end;
end;
/

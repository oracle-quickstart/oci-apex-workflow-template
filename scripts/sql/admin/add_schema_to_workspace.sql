-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

declare
   l_schema VARCHAR2(30) := '&1';
   l_apex_admin_user VARCHAR2(30) := '&2';
   l_workspace_admin VARCHAR2(30) := '&3';
   l_workspace_admin_password VARCHAR2(30) := '&4';
   l_workspace_admin_email VARCHAR2(30) := '&5';
   l_workspace_name VARCHAR2(30) := '&6';
   l_group_name VARCHAR2(30) := 'APEX Users';
   l_group_id NUMBER;
   l_body CLOB;

begin
    apex_instance_admin.add_schema(
        p_workspace      => l_workspace_name,
        p_schema         => l_schema);

end;
/
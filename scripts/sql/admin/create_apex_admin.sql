-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

declare
   l_user VARCHAR2(30) := '&1';
   l_password VARCHAR2(30) := '&2';
begin
		execute immediate 'create user '||l_user ||' identified by '||l_password|| ' default tablespace DATA quota unlimited on DATA';
		execute immediate 'grant connect to '||l_user;
		execute immediate 'grant resource to '||l_user;
		execute immediate 'grant dwrole to '||l_user;
		execute immediate 'grant create session to '||l_user;
		execute immediate 'grant APEX_ADMINISTRATOR_ROLE to '||l_user;
		execute immediate 'grant create user, drop user, alter user to '||l_user;
		execute immediate 'grant ADPUSER to '||l_user;
		execute immediate 'grant CONNECT to '||l_user;
		execute immediate 'grant CTXAPP to '||l_user;
		execute immediate 'grant ORDS_ADMINISTRATOR_ROLE to '||l_user;
		execute immediate 'grant PDB_DBA to '||l_user;
		execute immediate 'grant PROVISIONER to '||l_user;
		execute immediate 'grant RESOURCE to '||l_user;
		execute immediate 'grant SELECT_CATALOG_ROLE to '||l_user;
		execute immediate 'grant SODA_APP to '||l_user;
		execute immediate 'grant XS_CACHE_ADMIN to '||l_user;
		execute immediate 'grant XS_CONNECT to '||l_user;
		execute immediate 'grant XS_NAMESPACE_ADMIN to '||l_user;
		execute immediate 'grant XS_SESSION_ADMIN to '||l_user;
		execute immediate 'grant select on sys.dba_sys_privs to '||l_user;
		execute immediate 'grant create user, drop user, alter user to '||l_user;
		execute immediate 'grant create user, drop user, alter user to '||l_user;
		execute immediate 'grant datapump_cloud_exp to '||l_user;
		execute immediate 'grant datapump_cloud_imp to '||l_user;
		execute immediate 'grant execute on DBMS_DATAPUMP to '||l_user;

		begin
		    for c1 in (select privilege
		                     from sys.dba_sys_privs
		                    where grantee = 'APEX_GRANTS_FOR_NEW_USERS_ROLE' ) loop
		            execute immediate 'grant '||c1.privilege||' to '||l_user|| ' with admin option';
		    end loop;
    end;
end;
/
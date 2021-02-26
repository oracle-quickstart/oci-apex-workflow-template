-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

declare
      l_workspace_name varchar2(30) := '&1';
      l_workspace_admin varchar2(30) := '&2';
begin

      for x in ( select sid, serial# from v$session where username='&2' and status <> 'KILLED')
      loop
            execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
      end loop;
      execute immediate 'drop user ' || l_workspace_admin || ' cascade';

      apex_instance_admin.remove_workspace(
            p_workspace      => l_workspace_name
          , p_drop_users     => 'N'
          , p_drop_tablespaces => 'Y'
      );
      exception
        when others then
	    IF SQLCODE = -20987 THEN
            NULL; -- ignore workspace not exist error
          ELSE
            RAISE;
          END IF;
end;
/
declare
    l_schema varchar2(30) := '&1';
    l_workspace_admin varchar2(30) := '&2';
    l_workspace_base varchar2(30) := '&3';
begin
    for x in ( select sid, serial# from v$session where username=l_schema and status <> 'KILLED')
    loop
        execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
    end loop;
    for x in ( select sid, serial# from v$session where username=l_workspace_admin and status <> 'KILLED')
    loop
        execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
    end loop;
    begin
        execute immediate 'drop user '||l_schema||' cascade';
        execute immediate 'drop user '||l_workspace_admin||' cascade';
        APEX_INSTANCE_ADMIN.REMOVE_WORKSPACE(l_workspace_base, 'N', 'Y');
    exception
        when others then
	         IF SQLCODE = -1918 THEN
              NULL; -- if user does not exist then ignore
          ELSE
            RAISE;
         END IF;
    end;
end;
/
declare
    l_user varchar2(30) := 'WORKSHOP';
    l_workspace_base varchar2(30) := 'WS_WORKSHOP';
begin
    for x in ( select sid, serial# from v$session where username=l_user and status <> 'KILLED')
    loop
        execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
    end loop;
    begin
        execute immediate 'drop user '||l_user||' cascade';
    exception
        when others then
	         IF SQLCODE = -1918 THEN
              NULL; -- if user does not exist then ignore
          ELSE
            RAISE;
         END IF;
    end;
end;

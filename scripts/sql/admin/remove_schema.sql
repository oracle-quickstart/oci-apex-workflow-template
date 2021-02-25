declare
    l_schema varchar2(30) := '&1';
begin
    for x in ( select sid, serial# from v$session where username=l_schema and status <> 'KILLED')
    loop
        execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
    end loop;
    begin
        execute immediate 'drop user ' || l_schema || ' cascade';
    end;
end;
/
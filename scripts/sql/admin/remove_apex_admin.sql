-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

  declare
    l_user varchar2(30) := '&1';
  begin

    for x in ( select sid, serial# from v$session where username=l_user and status <> 'KILLED')
    loop
        execute immediate 'alter system kill session '''||x.sid||','||x.serial#||'''';
    end loop;
    begin
        execute immediate 'drop user '||l_user||' cascade';
    exception
      when others then
          null;
        end;
  exception
      when others then
        null;
  end;
/
declare
      l_user varchar2(30) := 'WORKSHOP';
      l_workspace_base varchar2(30) := 'WS_WORKSHOP';
begin

      apex_instance_admin.remove_workspace(
            p_workspace      => l_workspace_base
          , p_drop_users     => 'Y'
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

declare
   l_workspace_name VARCHAR2(30) := 'WS_WORKSHOP';
   l_workspace_id   NUMBER;
   l_schema_name    VARCHAR2(30) := 'WORKSHOP';
   l_app_alias    VARCHAR2(30) := 'OPP_TRACKER_QA';

begin
    apex_util.set_security_group_id(apex_util.find_security_group_id(l_workspace_name));

    select workspace_id into l_workspace_id
      from apex_workspaces
     where workspace = l_workspace_name;
    --
    apex_application_install.set_workspace_id( l_workspace_id );
    apex_application_install.generate_offset;
    apex_application_install.set_schema( l_schema_name);
    apex_application_install.set_application_alias( l_app_alias);
end;

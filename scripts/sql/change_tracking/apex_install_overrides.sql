-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

DECLARE
    l_workspace_id number;
    l_sg_id number;
BEGIN
    apex_util.set_workspace(p_workspace => '&1');
    l_workspace_id := apex_application_install.get_workspace_id;
    l_sg_id := apex_util.find_security_group_id (p_workspace => '&1');
    apex_util.set_security_group_id (p_security_group_id => l_sg_id);
    apex_application_install.set_workspace_id(p_workspace_id => l_workspace_id);
    apex_application_install.set_schema(p_schema => '&2');
    apex_application_install.set_application_id(p_application_id => &4);
    apex_application_install.set_application_alias( 'F&3' );
    apex_application_install.generate_offset();
    apex_application_install.SET_BUILD_STATUS(p_build_status => 'RUN_AND_BUILD');
    apex_application_install.set_auto_install_sup_obj( p_auto_install_sup_obj => true );
END;
/
@&5
/
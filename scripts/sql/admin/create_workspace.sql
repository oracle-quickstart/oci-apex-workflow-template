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
    apex_instance_admin.add_workspace(
        p_workspace      => l_workspace_name,
        p_primary_schema => l_schema);

    --Add the parsing db user of this application to allow apex_util.set_workspace to succeed
    apex_instance_admin.add_schema(
        p_workspace      => l_workspace_name,
        p_schema         => l_apex_admin_user);

    apex_util.set_workspace(
        p_workspace      => l_workspace_name);

    apex_util.set_security_group_id( 
        apex_util.find_security_group_id(p_workspace => l_workspace_name));
    l_group_id := APEX_UTIL.GET_GROUP_ID(l_group_name);

    if l_group_id IS NULL THEN
        APEX_UTIL.CREATE_USER_GROUP (
            p_id                => null,         -- trigger assigns PK
            p_group_name        => l_group_name,
            p_security_group_id => null,         -- defaults to current workspace ID
            p_group_desc        => 'workspace Users for an APEX automation example'
        );
    end if;

    -- for ATP/APEX Service we need to create database user before creating APEX users
    execute immediate 'create user '|| l_workspace_admin ||
                    ' identified by "'|| l_workspace_admin_password ||
                    '" default tablespace DATA quota unlimited on DATA';

    --grant all the privileges that a db user would get if provisioned by APEX
    for c1 in (select privilege
            from sys.dba_sys_privs
        where grantee = 'APEX_GRANTS_FOR_NEW_USERS_ROLE' ) loop
        execute immediate 'grant ' || c1.privilege || ' to ' || l_workspace_admin;
    end loop;

    apex_util.create_user (
    p_user_name                     =>  l_workspace_admin,
    p_first_name                    =>  'Workspace',
    p_last_name                     =>  'Admin',
    p_email_address                 =>  l_workspace_admin_email,
    p_web_password                  =>  l_workspace_admin_password,
    p_group_ids                     =>  l_group_id,
    p_allow_access_to_schemas       =>  l_schema,
    p_default_schema                =>  l_schema,
    p_developer_privs               =>  'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
    p_account_locked                =>  'N',
    p_failed_access_attempts        =>  0,
    p_change_password_on_first_use => 'N',
    p_first_password_use_occurred  => 'Y',
    p_allow_app_building_yn        => 'Y',
    p_allow_sql_workshop_yn        => 'Y',
    p_allow_websheet_dev_yn        => 'Y',
    p_allow_team_development_yn    => 'Y'
    );

    l_body :='Hi Workshop Admin

                You have successfully registered for the APEX Application with an example account.

                Login to your account with your temporary password
                Username:  '||LOWER(l_workspace_admin)||'
                Temporary password:  '||l_workspace_admin_password||'
    ';
    -- Network ACL to be configured for email to deliver
    apex_mail.send(
        p_to       => l_workspace_admin_email,
        p_from     => 'nobody@oracle.com',  -- put your email address here
        p_body     => l_body,
        p_subj     => 'Welcome to the APEX CI/CD Application');


    APEX_MAIL.PUSH_QUEUE;

end;
/
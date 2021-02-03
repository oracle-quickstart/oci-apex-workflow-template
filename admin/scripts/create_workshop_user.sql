declare
   l_user VARCHAR2(30) := 'WORKSHOP';
   l_password VARCHAR2(30) := 'WELcome##12345';
   l_workspace_base VARCHAR2(30) := 'WS_WORKSHOP';
   l_admin_user VARCHAR2(30) := 'APEXADMIN';
   l_group_name VARCHAR2(30) := 'APEX Users';
   l_workspace_admin VARCHAR2(30) := 'WORKSP_ADMIN';
   l_email VARCHAR2(30) := 'vanitha.subramanyam@oracle.com';
   l_group_id NUMBER;
   l_body CLOB;

begin


                execute immediate 'create user '||l_user ||' identified by '||l_password|| ' default tablespace DATA quota unlimited on DATA';
                execute immediate 'grant connect to '||l_user;
                execute immediate 'grant resource to '||l_user;
                execute immediate 'grant dwrole to '||l_user;
                execute immediate 'grant RESOURCE to '||l_user;
                execute immediate 'grant create session to '||l_user;

                begin
                    for c1 in (select privilege
                                     from sys.dba_sys_privs
                                    where grantee = 'APEX_GRANTS_FOR_NEW_USERS_ROLE' ) loop
                            execute immediate 'grant '||c1.privilege||' to '||l_user ;
                    end loop;
                 end;
                apex_instance_admin.add_workspace(
                    p_workspace      => l_workspace_base,
                    p_primary_schema => l_user);

                --Add the parsing db user of this application to allow apex_util.set_workspace to succeed
                apex_instance_admin.add_schema(
                    p_workspace      => l_workspace_base,
                    p_schema         => l_admin_user);

                apex_util.set_workspace(
                    p_workspace      => l_workspace_base);

                apex_util.set_security_group_id( apex_util.find_security_group_id( p_workspace => l_workspace_base));
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
		            execute immediate 'create user '||l_workspace_admin||' identified by "'||l_password||
                '" default tablespace DATA quota unlimited on DATA';

                --grant all the privileges that a db user would get if provisioned by APEX
                for c1 in (select privilege
                     from sys.dba_sys_privs
                    where grantee = 'APEX_GRANTS_FOR_NEW_USERS_ROLE' ) loop
                    execute immediate 'grant '||c1.privilege||' to '||l_workspace_admin;
                end loop;


                apex_util.create_user (
                p_user_name                     =>  l_workspace_admin,
                p_first_name                    =>  'Workspace',
                p_last_name                     =>  'Admin',
                p_email_address                 =>  l_email,
                p_web_password                  =>  l_password,
                p_group_ids                     =>  l_group_id,
                p_allow_access_to_schemas       =>  l_user,
                p_default_schema                =>  l_user,
                p_developer_privs               => 'ADMIN',
                p_account_locked                =>  'N',
                p_failed_access_attempts        =>  0,
                p_change_password_on_first_use  =>  'Y',
                p_first_password_use_occurred   =>  'Y');

                l_body :='Hi Workshop Admin

                          You have successfully registered for the APEX Application with an example account.

                          Login to your account with your temporary password
                          Username:  '||LOWER(l_workspace_admin)||'
                         Temporary password:  '||l_password||'
                ';
           -- Network ACL to be configured for email to deliver
           apex_mail.send(
                p_to       => l_email,
                p_from     => 'nobody@oracle.com',  -- put your email address here
                p_body     => l_body,
                p_subj     => 'Welcome to the APEX CI/CD Application');


            APEX_MAIL.PUSH_QUEUE;

end;

-- Copyright © 2021, Oracle and/or its affiliates. 
-- All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

DECLARE
   dp_id NUMBER; -- job id
   l_obj_storage_url VARCHAR2(1000) := 'https://objectstorage.us-ashburn-1.oraclecloud.com/p/Tt1P2LSq1HxuE6Jf5Q1cIxyHCG7uX9fSI1Vh_lq6zFXdRyCy8ep0lko7jL9SGgMT/n/ocisateam/b/datapump';
   l_schema_name VARCHAR2(100) := 'WORKSHOP';
   l_dump_file_name VARCHAR2(100) := l_schema_name||to_char(sysdate,'hhmiss');
   l_job_handle VARCHAR2(100) := l_schema_name||to_char(sysdate,'hhmiss');
BEGIN
    -- Defining an export DP job name and scope
    dp_id := dbms_datapump.open('EXPORT','FULL',NULL,l_job_handle,'COMPATIBLE');
    -- Adding the dump file
    dbms_datapump.add_file(dp_id, l_dump_file_name||'.dmp', 'DATA_PUMP_DIR',filetype => DBMS_DATAPUMP.KU$_FILE_TYPE_DUMP_FILE);
    -- Adding the log file
    dbms_datapump.add_file(dp_id, l_dump_file_name||'.log', 'DATA_PUMP_DIR',filetype => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);
    -- Specifying schema to export
    dbms_datapump.metadata_filter(dp_id, 'SCHEMA_EXPR', 'IN ('''||l_schema_name||''')');
    -- Once defined, the job starts
    dbms_datapump.start_job(dp_id);
    -- Once the jobs has been started, the session is dettached. Progress can be monitored from dbms_datapump.get_status.
    -- in case it is required, the job can be attached by means of the dbms_datapump.attach() function.
    -- Detaching the Job, it will continue to work in background.
    dbms_output.put_line('Detaching Job, it will run in background');
    dbms_datapump.detach(dp_id);
    -- In case an error is raise, the exception
    -- is captured and processed.
    -- store the backups in object storage
    begin
        for r in (select object_name, bytes
                    from dbms_cloud.list_files('DATA_PUMP_DIR') WHERE object_name like '%dmp%')
        loop
             dbms_cloud.put_object(credential_name => 'DEF_CRED_NAME',
               object_uri => l_obj_storage_url||'/o/'||r.object_name,
               directory_name => 'DATA_PUMP_DIR',
               file_name => r.object_name);
             UTL_FILE.FREMOVE('DATA_PUMP_DIR',r.object_name);

        end loop;
    end;
EXCEPTION
WHEN OTHERS THEN
dbms_datapump.stop_job(dp_id);
END;

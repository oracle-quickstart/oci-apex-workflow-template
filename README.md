# Apex CI-CD workflow template

## **Reference Architecture**

![](./images/apex-wf.png)

### ***Prerequisites***

1. JDK: Download from [https://www.oracle.com/java/technologies/javase-downloads.html](https://www.oracle.com/java/technologies/javase-downloads.html)

2. OCI CLI installed and configured (see [https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm))

## **STEP 1:** Get the template and required downloads

1. Use this repo as TEMPLATE

  ![](./images/template.png)

  Enter a repository name of your choice.

2. Clone your new repository (not this repo) locally.

3. Download SQLcl from [https://www.oracle.com/tools/downloads/sqlcl-downloads.html](https://www.oracle.com/tools/downloads/sqlcl-downloads.html)

4. Place the SQLcl zip file download in the root folder of the project

5. To setup SQLcl, run:

  ```bash
  ./setup_env.sh
  ```

## **STEP 2:** Terraform setup

1. Get in the `terraform` folder

  ```bash
  cd terraform
  ```

2. Create a `TF_VARS.sh` file

  ```bash
  cp TF_VARS.tpl TF_VARS.sh
  ```

3. Edit with your favorite editor and populate the following:

  ```bash
  export TF_VAR_user_ocid=ocid1.user.oc1..
  export TF_VAR_fingerprint=dc:6e:1c:d4:76:...
  export TF_VAR_private_key_path=~/.oci/oci_api_key.pem
  export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..
  export TF_VAR_region=us-ashburn-1
  ```

  These values come from your OCI CLI installation

4. Create a `terraform.tfvars` file from template

  ```bash
  cp terraform.tfvars.template terraform.tfvars
  ```

5. Populate the required variables

  ```
  region="us-ashburn-1"
  compartment_id="ocid1.compartment.oc1.."
  ```

  and edit the schema, workspace and user names as desired. The default looks like:

  ```  
  databases=[
      {
          "db_name" = "apexdev"
          "display_name" = "APEX_DEV"
          "cpu_core_count" = 1
          "storage_size_in_tbs" = 1
          "db_version" = "19c"
          "db_workload" = "OLTP"
          "is_free_tier" = true
          "license_model" = "LICENSE_INCLUDED"
          "envs" = ["dev", "stg", "tst"]
      },
      {
          "db_name" = "apexprd"
          "display_name" = "APEX_PRD"
          "cpu_core_count" = 1
          "storage_size_in_tbs" = 1
          "db_version" = "19c"
          "db_workload" = "OLTP"
          "is_free_tier" = true
          "license_model" = "LICENSE_INCLUDED"
          "envs" = ["prd"]
      }
  ]

  environments = {
      "dev" = {
          workspace_name = "WS"
          schema_name = "MYAPP"
          workspace_admin = "WS_ADMIN"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      },
      # if environments are on the same DB, 
      # the schema and workspace need a different name
      "stg" = {
          workspace_name = "WS_STG"
          schema_name = "MYAPP_STG"
          workspace_admin = "WS_ADMIN_STG"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
      "tst" = {
          workspace_name = "WS_TST"
          schema_name = "MYAPP_TST"
          workspace_admin = "WS_ADMIN_TST"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
      # on separate database, use the same name for schema and workspace
      "prd" = {        
          workspace_name = "WS"
          schema_name = "MYAPP"
          workspace_admin = "WS_ADMIN"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
  }
  ```

  This creates 2 databases (`APEX_DEV` and `APEX_PRD`), and 4 environments (`dev`, `tst`, `stg`, `prd`): `dev`, `tst`, and `stg` are on the `APEX_DEV` database and `prd` is on the `APEX_PRD` database

  Feel free to configure these as you need, however make sure that SCHEMA, WORKSPACE and WS_ADMIN names are different if setting up multiple environments in the same database.

  If you wanted to have all environment on the same database, it would look like:

  ```bash
  databases=[
    {
        "db_name" = "apexdev"
        "display_name" = "APEX_DEV"
        "cpu_core_count" = 1
        "storage_size_in_tbs" = 1
        "db_version" = "19c"
        "db_workload" = "OLTP"
        "is_free_tier" = true
        "license_model" = "LICENSE_INCLUDED"
        "envs" = ["dev", "stg", "tst", "prd"]
    }
  ]

  environments = {
      "dev" = {
          workspace_name = "WS_DEV"
          schema_name = "MYAPP_DEV"
          workspace_admin = "WS_ADMIN_DEV"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      },
      # if environments are on the same DB, 
      # the schema and workspace need a different name
      "stg" = {
          workspace_name = "WS_STG"
          schema_name = "MYAPP_STG"
          workspace_admin = "WS_ADMIN_STG"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
      "tst" = {
          workspace_name = "WS_TST"
          schema_name = "MYAPP_TST"
          workspace_admin = "WS_ADMIN_TST"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
      # on separate database, use the same name for schema and workspace
      "prd" = {        
          workspace_name = "WS_PRD"
          schema_name = "MYAPP_PRD"
          workspace_admin = "WS_ADMIN_PRD"
          apex_admin_email = "admin@local"
          ws_admin_email = "admin@local"
      }
  }
  ```

## **STEP 3:** Deploy

1. The whole stack and environments can be deployed and configured in one command:

  ```bash
  make init
  ```
  
  Type `yes` at the prompt to confirm applying the terraform stack.

  The terraform stacks generates environment files for each environment. The files are on the root folder, named *`<env_name>.env`* and they contain the credentials for user/schema/workspace for each environment.

  The script sets up all of the environments for you, ready to install a new app.

## **STEP 4:** Using the makefile

1. The makefile in this repository simplifies a lot of the tasks to be performed. Try 

  ```bash
  make help
  ```

  For the full list of functions:

  ```bash
  help                           This help.
  sql                            SQLcl shell as APEX ADMIN user
  sql-schema                     SQLcl shell as SCHEMA user
  wallet                         Get the Database wallet
  clean-wallets                  remove the wallets
  tf-apply                       Run the terraform stack
  tf-destroy                     Destroy the terraform stack
  create-apex-admin              Create the APEX admin user
  delete-apex-admin              Delete the APEX admin user
  create-cloud-creds             Create default cloud credential for the APEX ADMIN user to use datapump to Object Storage 
  create-schema                  Create schema
  delete-schema                  Delete schema
  create-ws                      Create schema, workspace, add schema to workspace and create workspace admin user
  delete-ws                      Delete workspace and its users
  export-app                     Export the Apex App. Specify ID=<app_id>
  import-app                     Import the Apex App. Specify ID=<app_id> NEWID=<new_app_id> (defaults to ID)
  changelog                      Generate a new Change Log for the schema
  update-schema                  Apply the Change Log to the schema
  snapshot                       Create a new change Log, and export the app. Specify ID=<app_id>
  update                         Apply the Change Log & import the app. Specify ID=<app_id> NEWID=<new_app_id> (defaults to ID)
  rollback                       Rollback changes. Specify ID=<app_id> NEWID=<new_app_id>
  init                           Deploy the database(s) and setup all the defined environments
  test                           Test (WIP)
  ```

  Many of these functions are sub-functions of the main functions describes here, giving you more granularity to manipulate specific objects.

  The main commands we will use are:

  - `init`: initialize the whole environment (`tf-apply` + `wallet` + `create-schema` + `create-ws` applied to each environment)
  - `snapshot ID=\<app_id\>`: to take a snapshot of the state of the application (`changelog` + `export-app`)
  - `update ID=\<app_id\>`: to update the app (`update-schema` + `import-app`)

  The other commands can be used to create additional environments (`create-schema`, `create-ws`) and manually perform specific task (`wallet`,`clean-wallets` to get and clean environment DB wallets) 

## **STEP 5:** Start developping

1. Login to the ATP database for dev: 

  - Go to **Oracle Databases -> Autonomous Transaction Processing** in your compartment
  - Click the database for dev (*APEX_DEV* if you used the default names)
  - Click **Tools** tab and under **Oracle Application Express**, click then **Open APEX**
  - Click **Workspace Sign-in**

    ![](.images/ws_signin.png)

  - Enter the credentials for the Workspace Admin user (*WS_ADMIN* if you used the default names) found in the *`dev.env`* file (WORKSPACE_ADMIN and WORKSPACE_ADMIN_PWD)

2. You can create a new application in the APEX interface, or use a template application from the gallery.

3. If you used an app from the gallery, make sure to UNLOCK it before the next steps:

  ![](./images/unlock.png)


## **STEP 6:** Take a snapshot of the state of the app

1. We use the LiquiBase tool to create snapshots of the schema, and the apex export tool to export the app itself.

2. Make note of the APP ID in the APEX UI, and take a snapshot of the app state with:

  ```bash
  make snapshot ID=<app_id>
  ```

  This will create a changelog of the schema and export the app.

  You can run the 2 operations separately with:

  ```bash
  make changelog
  ```

  and

  ```bash
  make export-app ID=<app_id>
  ```

3. check you current state into git:

  ```bash
  git add apps/
  git add changelogs/
  git commit -m"Initial state"
  git push origin master
  ```

4. To facilitate rollback, create a release branch

  ```bash
  git branch release/v1.0.0
  git push origin release/v1.0.0
  ```

## **STEP 7:** Deploy the app to another environment

1. With the app export and the schema changelog, we can reproduce the full application to another environment with:

  ```bash
  make update ENV=prd ID=<original_app_id> NEWID=<new_app_id> 
  ```

  Note that APEX APP IDs must be *unique* within a single database (regardless of SCHEMA or WORKSPACE), so if you created the `prd` environment in the same database as the `dev` environment, the *`new_app_id`* MUST be different from the *`original_app_id`*. We recommend using a fixed offset (like 1000)

  If you are deploying on a separate database, the *`new_app_id`* can be ommitted and it will default to the current APP ID, so if you used the default setup in terraform, you can do:

  ```bash
  make update ENV=prd ID=<original_app_id>
  ```

## **STEP 8:** Checking the deployment

1. Login to the ATP database for prd: 

  - Go to **Oracle Databases -> Autonomous Transaction Processing** in your compartment
  - Click the database for dev (*APEX_PRD* if you used the default names)
  - Click **Tools** tab and under **Oracle Application Express**, click then **Open APEX**
  - Click **Workspace Sign-in**

    ![](.images/ws_signin.png)

  - Enter the credentials for the Workspace Admin user (*WS_ADMIN* if you used the default names) found in the *`prd.env`* file (WORKSPACE_ADMIN and WORKSPACE_ADMIN_PWD)

2. You should find your application, and be able to run it.

## **STEP 9:** Make some changes

1. Back on the APEX_DEV database, make some changes:

  For example, add a table, or add a column in an existing table, or modify a component of the application

2. Create a new snapshot:

  ```bash
  make snapshot ID=<app_id>
  ```

3. Check your changes into git

  ```bash
  git add apps/
  git add changelogs/
  git commit -m"First state change"
  git push origin master
  ```

4. Create a new release branch

  ```bash
  git branch release/v1.0.1
  git push origin release/v1.0.1
  ```

5. Redeploy to prod

  ```bash
  make update ENV=prd ID=<app_id>
  ```

6. On the APEX_PRD DB, check that the changes have propagated.

## **STEP 10:** Rolling back changes

1. Rolling back consists in going back to a previous state. Using our release branches it's easy to rollback to a given version

2. Checkout the release branch to roll back to

  ```bash
  git checkout release/v1.0.0
  ```

3. Apply the rollback

  ```bash
  make rollback ENV=prd ID=<app_id>
  ```

4. 

## **STEP 11:** Create an additional environment

1. The `make` commands above take a variable *`ENV`* that define what `.env` file to use to create the environment. To create another environment, duplicate one of the `.env` file for the DB you want to use and rename it.

  *If you use the same target database, you MUST change the name of the SCHEMA and the WORKSPACE in the new `.env` file*

2. Get the wallet for the DB for this new environment:

  ```bash
  make wallet ENV=newprod
  ```

  (newprod being the basename of the .env file to use: `newprod.env`)

3. Then you can create the schema and workspace for the new environment using:

  ```bash
  make create-ws ENV=newprod
  ```

  *If you use a separate database, it is recommended to use the same SCHEMA and WORKSPACE names, but change the passwords*

## References

This code is used in the following solutions and labs:

- [LiveLab](https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/view-workshop?wid=799&clear=180&session=113472219650771)

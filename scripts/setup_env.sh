#!/bin/bash

# PLATFORM=$(uname)

# which java \
# || (curl -sLO -H 'Cookie: oraclelicense=accept-securebackup-cookie' -O https://download.oracle.com/otn-pub/java/jdk/14.0.2+12/205943a0976c4ed48cb16f1043c5c647/jdk-14.0.2_linux-x64_bin.rpm)


# # https://download.oracle.com/otn-pub/java/jdk/15.0.2+7/0d1cfde4252546c6931946de8db48ee2/jdk-15.0.2_osx-x64_bin.dmg

which sql \
|| (curl -sLO -H 'Cookie: oraclelicense=accept-securebackup-cookie' -O https://download.oracle.com/otn/java/sqldeveloper/sqlcl-20.4.1.351.1718.zip \
    && unzip sqlcl-20.4.1.351.1718.zip -d \
    && export PATH=$PATH:./sqlcl/bin/)

TERRAFORM_VERSION=0.14.6
which terraform \
|| (curl -sLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${PLATFORM,,}_amd64.zip
    && unzip terraform_${TERRAFORM_VERSION}_${PLATFORM,,}_amd64.zip \
    && mv terraform /usr/local/bin)

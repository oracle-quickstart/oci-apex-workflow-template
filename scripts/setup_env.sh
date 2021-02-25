#!/bin/bash

PLATFORM=$(uname)

which sql \
|| (curl -sLO -H 'Cookie: oraclelicense=accept-securebackup-cookie' -O https://download.oracle.com/otn/java/sqldeveloper/sqlcl-20.4.1.351.1718.zip \
    && unzip sqlcl-20.4.1.351.1718.zip -d \
    && export PATH=$PATH:./sqlcl/bin/)

TERRAFORM_VERSION=0.14.6
which terraform \
|| (curl -sLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${PLATFORM,,}_amd64.zip
    && unzip terraform_${TERRAFORM_VERSION}_${PLATFORM,,}_amd64.zip \
    && mv terraform /usr/local/bin)

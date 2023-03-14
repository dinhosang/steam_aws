#!/bin/bash

#
#  AWS CLI - INSTALL
##

echo "START: aws cli install"

sudo apt-get install awscli -y

echo "FINISH: aws cli install"

##
#   JQ - INSTALL (USEFUL FOR PARSING OUTPUT FROM AWS CLI)
##

echo "START: jq install"

sudo apt-get install jq -y

echo "FINISH: jq install"

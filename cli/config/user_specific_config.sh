#!/bin/bash


##
# IMPORT SECRETS
##


source ./cli/config/secrets.sh


##
#   AWS CONFIG
##


AWS_REGION=$_AWS_REGION
AWS_PROFILE=$_AWS_PROFILE


##
#   OS CONFIG
##


OS_VERSION='Ubuntu-22.04'
OS_SOURCE_AMI_NAME='ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*'
INSTANCE_LOGIN_USER_NAME='ubuntu'
INSTANCE_LOGIN_USER_PASSWORD=$_INSTANCE_LOGIN_USER_PASSWORD


##
#   VOLUME CONFIG
##


ROOT_VOLUME_NAME='/dev/sda1'
ROOT_VOLUME_SIZE=12


##
#   EC2 CONFIG
##


INSTANCE_TYPE='t3a.medium'
# INSTANCE_TYPE='g3s.xlarge'


##
#   LOCAL IPS
##


IP_V4=$_IP_V4
IP_V6=$_IP_V6

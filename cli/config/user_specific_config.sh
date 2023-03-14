#!/bin/bash


##
# IMPORT SECRETS
##


source ./cli/config/secrets.sh


##
#   AWS CONFIG
##


export AWS_REGION=$_AWS_REGION
export AWS_PROFILE=$_AWS_PROFILE


##
#   OS CONFIG
##


export OS_VERSION='Ubuntu-22.04'
export OS_SOURCE_AMI_NAME='ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*'
export INSTANCE_LOGIN_USER_NAME='ubuntu'
export INSTANCE_LOGIN_USER_PASSWORD=$_INSTANCE_LOGIN_USER_PASSWORD


##
#   VOLUME CONFIG
##


export ROOT_VOLUME_NAME='/dev/sda1'
export ROOT_VOLUME_SIZE=12


##
#   EC2 CONFIG
##


export INSTANCE_TYPE='t3a.medium'


##
#   LOCAL IPS
##


export IP_V4=$_IP_V4
export IP_V6=$_IP_V6

#!/bin/bash


##
#   NOTE: 
#
#       BEFORE CHANGING VALUES HERE ENSURE ALL EXISTING AWS RESOURCES HAVE BEEN 
#       PRUNED / DELETED USING EXISTING VALUES.
##


##
#   AMI CONFIG
##


AMI_NAME='steam_play_instance'
AMI_SNAPSHOT_TAG_PURPOSE='steam_play_instance'


##
#   AWS TAG KEYS
##


TAG_KEY_PURPOSE='Purpose'
TAG_KEY_OS_VERSION='OS_Version'


##
#   SG CONFIG
##


SG_NAME_PREFIX_AWS_CONNECT='ssh'
SG_NAME_PREFIX_RDP='rdp'


##
#   EC2 CONFIG
##


INSTANCE_PROFILE_NAME='steam_server'
INSTANCE_TAG_PURPOSE='steam_server'


##
#   STARTUP SCRIPTS
##


STARTUP_DIR=/startup
STARTUP_SCRIPT_CONTROL_PATH=/startup/00_startup.sh
STARTUP_COMPLETED_SCRIPT_PATH=/startup/startup_completed.txt

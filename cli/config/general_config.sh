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


export AMI_NAME='steam_play_instance'
export AMI_SNAPSHOT_TAG_PURPOSE='steam_play_instance'


##
#   AWS TAG KEYS
##


export TAG_KEY_PURPOSE='Purpose'
export TAG_KEY_OS_VERSION='OS_Version'


##
#   SG CONFIG
##


export SG_NAME_PREFIX_AWS_CONNECT='ssh'
export SG_NAME_PREFIX_RDP='rdp'


##
#   EC2 CONFIG
##


export INSTANCE_PROFILE_NAME='steam_server'
export INSTANCE_TAG_PURPOSE='steam_server'


##
#   STARTUP SCRIPTS
##


export STARTUP_DIR=/startup
export STARTUP_SCRIPT_CONTROL_PATH=/startup/00_startup.sh
export STARTUP_COMPLETED_SCRIPT_PATH=/startup/startup_completed.txt


##
#   COLOURS
##


export ANSI_PREFIX='\033['
export ANSI_SUFFIX='m'

export ANSI_RED="${ANSI_PREFIX}1;31${ANSI_SUFFIX}"
export ANSI_YELLOW="${ANSI_PREFIX}1;33${ANSI_SUFFIX}"
export ANSI_GREEN="${ANSI_PREFIX}1;32${ANSI_SUFFIX}"
export ANSI_CYAN="${ANSI_PREFIX}1;36${ANSI_SUFFIX}"
export ANSI_GREY="${ANSI_PREFIX}0;37${ANSI_SUFFIX}"

export ANSI_CLEAR="${ANSI_PREFIX}0${ANSI_SUFFIX}"


##
#   LOGGING
##


export LOG_ERROR=$ANSI_RED
export LOG_WARN=$ANSI_YELLOW
export LOG_INFO=$ANSI_GREEN
export LOG_START=$ANSI_CYAN
export LOG_FINISH=$ANSI_CYAN
export LOG_STEP=$ANSI_GREY

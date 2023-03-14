#!/bin/bash

# NOTE: should not require modification

##
#   EXTERNAL URLS
##


export IP_4_QUERY_URL='ip4only.me/api/'
export IP_6_QUERY_URL='ip6only.me/api/'


##
#   COMMAND KEYS
##


export HELP='help'
export AMI='ami'
export INSTANCE='instance'
export SNAPSHOT='snapshot'


##
#   SUB-COMMAND KEYS
##


export CREATE='create'
export DELETE='delete'
export UPDATE='update'
export PRUNE='prune'


##
#   FLAGS
##


export PROFILE_FLAG='-p'
export REGION_FLAG='-r'


##
#   ARRAYS OF VALID (SUB-)COMMANDS
##


export COMMANDS=("$HELP" "$AMI" "$INSTANCE" "$SNAPSHOT")
export AMI_SUB_COMMANDS=("$HELP" "$CREATE" "$UPDATE" "$DELETE" "$PRUNE")
export INSTANCE_SUB_COMMANDS=("$HELP" "$CREATE" "$DELETE" "$PRUNE")
export SNAPSHOT_SUB_COMMANDS=("$HELP" "$DELETE" "$PRUNE")

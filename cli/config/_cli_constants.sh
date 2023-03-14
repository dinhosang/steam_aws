#!/bin/bash

# NOTE: should not require modification

##
#   EXTERNAL URLS
##


IP_4_QUERY_URL='ip4only.me/api/'
IP_6_QUERY_URL='ip6only.me/api/'


##
#   COMMAND KEYS
##


HELP='help'
AMI='ami'
INSTANCE='instance'
SNAPSHOT='snapshot'


##
#   SUB-COMMAND KEYS
##


CREATE='create'
DELETE='delete'
UPDATE='update'
PRUNE='prune'


##
#   FLAGS
##


PROFILE_FLAG='-p'


##
#   ARRAYS OF VALID (SUB-)COMMANDS
##


COMMANDS=($HELP $AMI $INSTANCE $SNAPSHOT)
AMI_SUB_COMMANDS=($HELP $CREATE $UPDATE $DELETE $PRUNE)
INSTANCE_SUB_COMMANDS=($HELP $CREATE $DELETE $PRUNE)
SNAPSHOT_SUB_COMMANDS=($HELP $DELETE $PRUNE)

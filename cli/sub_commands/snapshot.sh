#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh

source ./cli/aws_resources/snapshot/index.sh


##
#   FUNCTIONS
##


_delete_all_but_most_recent_snapshot() {
    
    echo "START: prune volume snapshots"
    

    ##
    #   SNAPSHOTS - RETRIEVE IDs
    ##


    local snapshot_ids=($(_get_volume_snapshot_ids false))


    if [ -z "$snapshot_ids" ]; then

        echo "INFO: No additional snapshots found"

    else

        ##
        #   SNAPSHOTS - DELETE
        ##


       _delete_snapshot ${snapshot_ids[*]}

    fi

    echo "FINISH: prune volume snapshots"
}

_delete_most_recent_snapshot() {
    
    echo "START: delete most recent volume snapshot"
    

    ##
    #   SNAPSHOTS - RETRIEVE IDs
    ##


    local snapshot_ids=($(_get_volume_snapshot_ids true))


    if [ -z "$snapshot_ids" ]; then

        echo "INFO: No snapshot found"

    else

        ##
        #   SNAPSHOTS - DELETE
        ##


       _delete_snapshot ${snapshot_ids[*]}

    fi

    echo "FINISH: delete most recent volume snapshot"
}

#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   FUNCTIONS
##


_delete_snapshot() {
    
    echo "START: delete snapshot"

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'At least one snapshot id must be passed to "_delete_snapshot".\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local SNAPSHOT_IDS=(${@})


    ##
    #   SNAPSHOTS - LOOP FOR DELETION
    ##


    for snapshot_id in ${SNAPSHOT_IDS[*]}; do

        echo "STEP: deleting volume snapshot '$snapshot_id'"

        ##
        #   SNAPSHOT - DELETE
        ##


        local _result=$(aws --profile $AWS_PROFILE ec2 delete-snapshot \
            --region $AWS_REGION \
            --snapshot-id $snapshot_id
        )

        echo "STEP: volume snapshot '$snapshot_id' deleted"

    done

    echo "FINISH: delete snapshot"
}

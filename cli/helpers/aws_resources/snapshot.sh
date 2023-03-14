#!/bin/bash


##
#   FUNCTIONS
##


_get_volume_snapshot_ids() {

    ##
    #   CONFIG
    ##


    local LATEST_SNAPSHOT=true


    ##
    #   POSSIBLE INPUT
    ##


    if [ ${1+x} ]; then 
        
        LATEST_SNAPSHOT=$1

    fi


    ##
    #   SNAPSHOT IDs - DETERMINE WHICH TO RETRIEVE
    ##


    local query_instance_array_indexes='0'

    if ! [[ $LATEST_SNAPSHOT == true ]]; then

        query_instance_array_indexes='1:'

    fi


    ##
    #   SNAPSHOT IDs - RETRIEVE
    ##


    local snapshot_ids_json_array=$(aws --profile $AWS_PROFILE ec2 describe-snapshots \
        --region $AWS_REGION \
        --filters Name=tag:$TAG_KEY_PURPOSE,Values=$AMI_SNAPSHOT_TAG_PURPOSE  \
        --query "reverse(sort_by(Snapshots,&StartTime))[$query_instance_array_indexes].[SnapshotId][]"
    )

    local snapshot_ids=$(echo ${snapshot_ids_json_array} | jq -r '.? | join(" ")' )

    echo $snapshot_ids
}

_check_snapshot_exists() {

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'SNAPSHOT_ID not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi

    local SNAPSHOT_ID=$1

    aws --profile $AWS_PROFILE ec2 describe-snapshots \
        --region $AWS_REGION \
        --snapshot-ids $SNAPSHOT_ID > /dev/null 2>&1
}

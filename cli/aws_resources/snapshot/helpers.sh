#!/bin/bash


_aws_resources_snapshot_helpers_module() {
    
    export AWS_RESOURCES_SNAPSHOT_HELPERS_MODULE_IMPORTED=true


    ###


    source ./cli/helpers/index.sh


    ###


    get_volume_snapshot_ids() {

        # NOTE: if this is true it'll grab ONLY the id of the latest snapshot
        # NOTE: if this is false it'll grab the ids of every snapshot EXCEPT the latest snapshot
        local should_target_latest_snapshot=true


        ###


        if [ ${1+x} ]; then 
            
            should_target_latest_snapshot=$1

        fi


        ###


        local query_instance_array_indexes='0'

        if ! [[ $should_target_latest_snapshot == true ]]; then

            query_instance_array_indexes='1:'

        fi


        ###


        local -r snapshot_ids_json_array=$(aws --profile $AWS_PROFILE ec2 describe-snapshots \
            --region $AWS_REGION \
            --filters Name=tag:$TAG_KEY_PURPOSE,Values=$AMI_SNAPSHOT_TAG_PURPOSE  \
            --query "reverse(sort_by(Snapshots,&StartTime))[$query_instance_array_indexes].[SnapshotId][]"
        )

        local -r snapshot_ids=$(echo "${snapshot_ids_json_array}" | jq -r '.? | join(" ")' )


        ###


        echo "$snapshot_ids"
    }

    does_snapshot_exist_throw_if_not() {

        if [ -z ${1+x} ]; then 
            
            log_error 'snapshot id not found - a snapshot id must be in as the first argument to function'

            exit 1

        fi


        ###


        local -r SNAPSHOT_ID=$1


        ###


        aws --profile $AWS_PROFILE ec2 describe-snapshots \
            --region $AWS_REGION \
            --snapshot-ids "$SNAPSHOT_ID" > /dev/null 2>&1
    }
}


###


if [ -z $AWS_RESOURCES_SNAPSHOT_HELPERS_MODULE_IMPORTED ]; then 

    _aws_resources_snapshot_helpers_module

fi

#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   HELPERS
##


_get_running_instance_ids() {

    ##
    #   CONFIG
    ##


    local LATEST_RUNNING=true


    ##
    #   POSSIBLE INPUT
    ##


    if [ ${1+x} ]; then 
        
        LATEST_RUNNING=$1

    fi


    ##
    #   INSTANCE IDs - DETERMINE WHICH TO RETRIEVE
    ##


    local query_instance_array_indexes='0'

    if ! [[ $LATEST_RUNNING == true ]]; then

        query_instance_array_indexes='1:'

    fi


    ##
    #   INSTANCE IDs - RETRIEVE
    ##


    local instance_ids_json_array=$(aws --profile $AWS_PROFILE ec2 describe-instances \
        --region $AWS_REGION \
        --filters "Name=tag:$TAG_KEY_PURPOSE,Values=$INSTANCE_TAG_PURPOSE" "Name=instance-state-name,Values=running" \
        --query "reverse(sort_by(Reservations[].Instances[],&LaunchTime))[$query_instance_array_indexes].[InstanceId][]"
    )

    local instance_ids=$(echo ${instance_ids_json_array} | jq -r '.? | join(" ")' )

    echo $instance_ids
}

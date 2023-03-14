#!/bin/bash

_aws_resources_ec2_helpers_module() {

    export AWS_RESOURCES_EC2_HELPERS_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    ###

    get_running_instance_ids() {

        # NOTE: if this is true it'll grab ONLY the id of the latest instance
        # NOTE: if this is false it'll grab the ids of every instance EXCEPT the latest instance
        local should_target_latest_ec2=true

        ###

        if [ ${1+x} ]; then

            should_target_latest_ec2=$1

        fi

        ###

        local query_instance_array_indexes='0'

        if ! [[ $should_target_latest_ec2 == true ]]; then

            query_instance_array_indexes='1:'

        fi

        ###

        local -r instance_ids_json_array=$(
            aws --profile $AWS_PROFILE ec2 describe-instances \
                --region $AWS_REGION \
                --filters "Name=tag:$TAG_KEY_PURPOSE,Values=$INSTANCE_TAG_PURPOSE" "Name=instance-state-name,Values=running" \
                --query "reverse(sort_by(Reservations[].Instances[],&LaunchTime))[$query_instance_array_indexes].[InstanceId][]"
        )

        local -r instance_ids=$(echo "${instance_ids_json_array}" | jq -r '.? | join(" ")')

        ###

        echo "$instance_ids"
    }

    is_instance_terminated_throw_if_not() {

        if [ -z ${1+x} ]; then

            log_error 'instance id not found - an instance id must passed in as the first argument'

            exit 1

        fi

        local -r INSTANCE_ID=$1

        ###

        aws --profile $AWS_PROFILE ec2 wait instance-terminated \
            --region $AWS_REGION \
            --instance-ids "$INSTANCE_ID" >/dev/null 2>&1
    }
}

###

if [ -z $AWS_RESOURCES_EC2_HELPERS_MODULE_IMPORTED ]; then

    _aws_resources_ec2_helpers_module

fi

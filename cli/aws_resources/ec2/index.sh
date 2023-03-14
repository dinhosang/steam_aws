#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh

source ./cli/aws_resources/sg/index.sh
source ./cli/aws_resources/instance_profile/index.sh


##
#   FUNCTIONS
##


_create_ec2(){

    echo "START: create EC2"


    ##
    #   CONFIG
    ##


    local SG_NAME_AWS_CONN=$(_get_sg_name $SG_NAME_PREFIX_AWS_CONNECT)

    local SG_NAME_RDP=$(_get_sg_name $SG_NAME_PREFIX_RDP)


    ##
    #   GRAB LATEST AMI
    ##


    local latest_ami_id=$(_get_active_ami_ids true)

    echo "STEP: using ami - '$latest_ami_id'"


    ##
    #   RUN INSTANCE
    ##


    local created_instance_details=$(aws --profile $AWS_PROFILE ec2 run-instances \
        --region $AWS_REGION \
        --instance-type $INSTANCE_TYPE \
        --image-id $latest_ami_id \
        --security-groups $SG_NAME_RDP $SG_NAME_AWS_CONN \
        --iam-instance-profile Name=$INSTANCE_PROFILE_NAME \
        --block-device-mappings "DeviceName=$ROOT_VOLUME_NAME,Ebs={VolumeSize=$ROOT_VOLUME_SIZE}" \
        --user-data $'#!/bin/bash\n/01_account.sh' \
        --tag-specifications "ResourceType=instance,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$INSTANCE_TAG_PURPOSE}]" \
            "ResourceType=volume,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$INSTANCE_TAG_PURPOSE}]"
    )


    local created_instance_id=$(echo $created_instance_details | jq -r '.Instances[0].InstanceId')

    ##
    #   INSTANCE - WAIT FOR RUNNING
    ##


    local instance_running=false

    while [ $instance_running == false ]; do

        local _instance_details_found=$(aws --profile $AWS_PROFILE ec2 describe-instance-status \
            --region $AWS_REGION \
            --instance-ids $created_instance_id \
            --filters "Name=instance-state-name, Values=running"
        )

        local is_instance_running=$(echo $_instance_details_found | jq -r '.InstanceStatuses != []')

        if [ $is_instance_running == true ]; then

            instance_running=true

            echo "STEP: instance has a running state, but may still need to finish initialising before it can be used."

        else

            local sleep_seconds=5

            echo "STEP: instance not running, sleeping for $sleep_seconds seconds before checking again"
            
            sleep $sleep_seconds

        fi

    done

    echo "FINISH: create EC2"

}

_delete_ec2(){

    echo "START: delete EC2"


    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'At least one instance id must be passed to "_delete_ec2".\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local INSTANCE_IDS=(${@})


    ##
    #   INSTANCES - LOOP FOR DELETION
    ##


    for ec2_instance_id in ${INSTANCE_IDS[*]}; do

        echo "STEP: terminating instance '$ec2_instance_id'"

        ##
        #   INSTANCE - DELETE
        ##


        local _result=$(aws --profile $AWS_PROFILE ec2 terminate-instances \
            --region $AWS_REGION \
            --instance-ids $ec2_instance_id
        )


        ##
        #   INSTANCE - CONFIRM DELETED
        ##


        local _result=$(aws --profile $AWS_PROFILE ec2 wait instance-terminated \
            --region $AWS_REGION \
            --instance-ids $ec2_instance_id
        )

        echo "STEP: instance '$ec2_instance_id' terminated"

    done

    echo "FINISH: delete EC2"

}

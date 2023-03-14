#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh


##
#   FUNCTIONS
##


_create_ami_via_packer() {

    echo "START: create AMI via packer"

    packer build \
        -var "region=$AWS_REGION" \
        -var "profile=$AWS_PROFILE" \
        -var "ami_name=$AMI_NAME" \
        -var "purpose=$AMI_SNAPSHOT_TAG_PURPOSE" \
        -var "root_volume_name=$ROOT_VOLUME_NAME" \
        -var "os_version=$OS_VERSION" \
        -var "instance_type=$INSTANCE_TYPE" \
        -var "os_source_ami_name=$OS_SOURCE_AMI_NAME" \
        -var "instance_login_user_name=$INSTANCE_LOGIN_USER_NAME" \
        -var "instance_login_user_password=$INSTANCE_LOGIN_USER_PASSWORD" \
        -var "startup_dir=$STARTUP_DIR" \
        -var "startup_control_script_path=$STARTUP_SCRIPT_CONTROL_PATH" \
        -var "startup_completed_script_path=$STARTUP_COMPLETED_SCRIPT_PATH" \
        ./packer

    echo "FINISH: create AMI via packer"
}

_delete_ami() {
    
    echo "START: delete AMI"

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'At least one ami id must be passed to "_delete_ami".\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local AMI_IDS=(${@})


    ##
    #   AMIs - LOOP FOR DELETION
    ##


    for ami_id in ${AMI_IDS[*]}; do

        echo "STEP: de-registering ami '$ami_id'"

        ##
        #   AMI - DELETE
        ##


        local _result=$(aws --profile $AWS_PROFILE ec2 deregister-image \
            --region $AWS_REGION \
            --image-id $ami_id
        )


        ##
        #   AMI - CONFIRM DELETION
        ##


        local image_deleted=false

        {
            # try

            echo "STEP: checking ami '$ami_id' was de-registered"

            _check_image_exists $ami_id

        } || {
            
            # catch

            image_deleted=true

        }

        if [ $image_deleted == true ]; then

            echo "STEP: ami '$ami_id' de-registered"

        else

            echo "WARN: ami '$ami_id' may NOT have been deleted"

        fi

    done

    echo "FINISH: delete AMI"
}

_create_ami_via_aws_cli_and_instance_id() {
    
    echo "START: create AMI via aws cli and from latest instance"

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'INSTANCE_ID must be passed to "_create_ami_via_aws_cli_and_instance_id".\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local INSTANCE_ID=$1
    

    ##
    #   AMI - CREATE
    ##


    echo "STEP: creating AMI from '$INSTANCE_ID'"
        
    local create_ami_details=$(aws --profile $AWS_PROFILE ec2 create-image \
        --region $AWS_REGION \
        --instance-id $INSTANCE_ID \
        --name "${AMI_NAME}_$(get_timestamp)" \
        --tag-specifications "ResourceType=image,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$AMI_SNAPSHOT_TAG_PURPOSE},{Key=$TAG_KEY_OS_VERSION,Value=$OS_VERSION}]" "ResourceType=snapshot,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$AMI_SNAPSHOT_TAG_PURPOSE},{Key=$TAG_KEY_OS_VERSION,Value=$OS_VERSION}]"
    )


    ##
    #   AMI - WAIT
    ##


    local ami_id=$(echo $create_ami_details | jq -r '.ImageId')

    local ami_is_ready=false

    while [ $ami_is_ready == false ]; do

        local describe_ami_details=$(aws --profile $AWS_PROFILE ec2 describe-images \
            --region $AWS_REGION \
            --image-ids $ami_id \
            --query "Images[0].State"
        )

        local status_equals_available=$(echo $describe_ami_details | jq -r '. == "available"')

        if [ $status_equals_available == true ]; then

            ami_is_ready=true

            echo "STEP: ami is now available"

        else

            local sleep_seconds=20

            echo "STEP: ami is not yet available, sleeping for $sleep_seconds seconds before checking again"
            
            sleep $sleep_seconds

        fi

    done

    echo "FINISH: create AMI via aws cli and from latest instance"
}

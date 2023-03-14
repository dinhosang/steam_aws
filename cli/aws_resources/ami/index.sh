#!/bin/bash


_aws_resources_ami_module() {

    export AWS_RESOURCES_AMI_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh
    
    source ./cli/helpers/index.sh
    source ./cli/aws_resources/ami/helpers.sh


    ###


    create_ami_via_packer() {

        log_start "create AMI via packer"


        ###


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


        ###


        log_finish "create AMI via packer"
    }

    delete_ami() {
        
        log_start "delete AMI"

        
        ###


        if [ -z ${1+x} ]; then 
            
            log_error "at least one ami id must be passed to 'delete_ami()'"

            exit 1

        fi


        ###


        local ami_ids_to_delete

        read -r -a ami_ids_to_delete <<< "${*}"

        log_info "amis to terminate: '[${ami_ids_to_delete[*]}]'"


        ###


        for ami_id in "${ami_ids_to_delete[@]}"; do

            log_step "de-registering ami - '$ami_id'"

            local _result

            _result=$(aws --profile $AWS_PROFILE ec2 deregister-image \
                --region $AWS_REGION \
                --image-id "$ami_id"
            )


            ###


            local image_deleted=false

            {
                # try

                log_step "checking ami '$ami_id' was de-registered"

                does_image_exist_throw_if_not "$ami_id"

            } || {
                
                # catch

                image_deleted=true

            }


            ###


            if [ $image_deleted == true ]; then

                log_step "ami '$ami_id' de-registered"

            else

                log_warn "ami '$ami_id' may NOT have been deleted"

            fi

        done


        ###


        log_finish "delete AMI"
    }

    create_ami_via_aws_cli_and_instance_id() {
        
        log_start "create AMI via aws cli from latest running instance"

        
        ###


        if [ -z ${1+x} ]; then 
            
            log_error "instance id must be passed to 'create_ami_via_aws_cli_and_instance_id()'"

            exit 1

        fi


        ###


        local -r INSTANCE_ID=$1
        

        ###


        log_step "creating AMI from '$INSTANCE_ID'"
            
        local -r create_ami_details=$(aws --profile $AWS_PROFILE ec2 create-image \
            --region $AWS_REGION \
            --instance-id "$INSTANCE_ID" \
            --name "${AMI_NAME}_$(get_timestamp)" \
            --tag-specifications "ResourceType=image,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$AMI_SNAPSHOT_TAG_PURPOSE},{Key=$TAG_KEY_OS_VERSION,Value=$OS_VERSION}]" "ResourceType=snapshot,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$AMI_SNAPSHOT_TAG_PURPOSE},{Key=$TAG_KEY_OS_VERSION,Value=$OS_VERSION}]"
        )


        ###


        local -r ami_id=$(echo "$create_ami_details" | jq -r '.ImageId')

        local ami_is_ready=false

        local -r sleep_seconds=20

        while [ $ami_is_ready == false ]; do

            local describe_ami_details

            describe_ami_details=$(aws --profile $AWS_PROFILE ec2 describe-images \
                --region $AWS_REGION \
                --image-ids "$ami_id" \
                --query "Images[0].State"
            )

            local status_equals_available

            status_equals_available=$(echo "$describe_ami_details" | jq -r '. == "available"')

            if [ "$status_equals_available" == true ]; then

                ami_is_ready=true

                log_info "new ami is now available"

            else

                log_info  'new ami is not yet available'

                log_step "sleeping for $sleep_seconds seconds before checking again"
                
                sleep $sleep_seconds

            fi

        done


        ###


        log_finish "create AMI via aws cli from latest running instance"
    }
}


###


if [ -z $AWS_RESOURCES_AMI_MODULE_IMPORTED ]; then 

    _aws_resources_ami_module

fi

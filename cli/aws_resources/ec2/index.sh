#!/bin/bash


_aws_resources_ec2_module() {

    export AWS_RESOURCES_EC2_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh
    source ./cli/aws_resources/ami/helpers.sh
    source ./cli/aws_resources/ec2/helpers.sh
    source ./cli/aws_resources/sg/helpers.sh


    ###


    create_ec2(){

        log_start "create ec2"


        ###


        local SG_NAME_AWS_CONN=$(get_sg_name $SG_NAME_PREFIX_AWS_CONNECT)

        local SG_NAME_RDP=$(get_sg_name $SG_NAME_PREFIX_RDP)


        ###


        local latest_ami_id=$(get_active_ami_ids true)

        log_info "using ami - '$latest_ami_id'"


        ###


        log_step 'setting up user data'

        local user_data_file_path="cli/aws_resources/ec2/user_data.txt"
        local user_data_file_path_copy="${user_data_file_path}.copy"

        sed -e "s|{{STARTUP_SCRIPT_CONTROL_PATH}}|${STARTUP_SCRIPT_CONTROL_PATH}|" $user_data_file_path > $user_data_file_path_copy


        ###


        log_step "launching instance"

        local created_instance_details=$(aws --profile $AWS_PROFILE ec2 run-instances \
            --region $AWS_REGION \
            --instance-type $INSTANCE_TYPE \
            --image-id $latest_ami_id \
            --security-groups $SG_NAME_RDP $SG_NAME_AWS_CONN \
            --iam-instance-profile Name=$INSTANCE_PROFILE_NAME \
            --block-device-mappings "DeviceName=$ROOT_VOLUME_NAME,Ebs={VolumeSize=$ROOT_VOLUME_SIZE}" \
            --user-data file://${user_data_file_path_copy} \
            --tag-specifications "ResourceType=instance,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$INSTANCE_TAG_PURPOSE}]" \
                "ResourceType=volume,Tags=[{Key=$TAG_KEY_PURPOSE,Value=$INSTANCE_TAG_PURPOSE}]"
        )

        local created_instance_id=$(echo $created_instance_details | jq -r '.Instances[0].InstanceId')

        log_info "created instance - '$created_instance_id'"


        ###


        log_step 'cleanup user data'

        rm $user_data_file_path_copy


        ###


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

                log_info "instance has a running state, but may still need to finish initialising before it can be used."

            else

                local sleep_seconds=5

                log_info "instance '$created_instance_id' not yet running"

                log_step "sleeping for $sleep_seconds seconds before checking again"
                
                sleep $sleep_seconds

            fi

        done


        ###


        log_finish "create ec2"
    }

    delete_ec2(){

        log_start "delete ec2"


        ###


        if [ -z ${1+x} ]; then 
            
            log_error "at least one instance id must be passed to 'delete_ec2()'"

            exit 1

        fi


        ###


        local INSTANCE_IDS=(${@})


        ###


        for ec2_instance_id in ${INSTANCE_IDS[*]}; do

            log_step "terminating instance - '$ec2_instance_id'"

            local _result=$(aws --profile $AWS_PROFILE ec2 terminate-instances \
                --region $AWS_REGION \
                --instance-ids $ec2_instance_id
            )


            ###


            local instance_deleted=true

            {
                # try

                log_step "confirming instance '$ec2_instance_id' was terminated"

                is_instance_terminated_throw_if_not $ec2_instance_id

            } || {
                
                # catch

                instance_deleted=false

            }


            ###


            if [ $instance_deleted == true ]; then

                log_info "instance '$ec2_instance_id' terminated"

            else

                log_warn "instance '$ec2_instance_id' may NOT have been terminated"

            fi

        done

        
        ###

        
        log_finish "delete ec2"

    }
}


###


if [ -z $AWS_RESOURCES_EC2_MODULE_IMPORTED ]; then 

    _aws_resources_ec2_module

fi

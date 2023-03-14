#!/bin/bash

_aws_resources_instance_profile_module() {

    export AWS_RESOURCES_INSTANCE_PROFILE_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    source ./cli/helpers/index.sh
    source ./cli/aws_resources/instance_profile/helpers.sh

    ###

    create_instance_profile() {

        log_start "create instance profile"

        ###

        local profile_exists=true

        {
            # try

            log_step "checking if instance profile '$INSTANCE_PROFILE_NAME' exists"

            does_profile_exist_throw_if_not

        } || {

            # catch

            profile_exists=false
        }

        ###

        if [ $profile_exists == true ]; then

            log_info "instance profile '$INSTANCE_PROFILE_NAME' alrady exists - skipping creation"

        else

            log_step "creating instance profile '$INSTANCE_PROFILE_NAME'"

            local -r _result_create=$(
                aws --profile $AWS_PROFILE iam create-instance-profile \
                    --region $AWS_REGION \
                    --instance-profile-name $INSTANCE_PROFILE_NAME
            )

            local -r _result_exists=$(
                aws --profile $AWS_PROFILE iam wait instance-profile-exists \
                    --region $AWS_REGION \
                    --instance-profile-name $INSTANCE_PROFILE_NAME
            )

        fi

        ###

        log_finish "create instance profile"
    }

    delete_instance_profile() {

        log_start "delete instance profile"

        ###

        local profile_exists=true

        {
            # try

            log_step "checking if instance profile '$INSTANCE_PROFILE_NAME' exists"

            does_profile_exist_throw_if_not

        } || {

            # catch

            profile_exists=false

        }

        ###

        if [ $profile_exists == true ]; then

            log_step "deleting instance profile '$INSTANCE_PROFILE_NAME'"

            local -r _result=$(
                aws --profile $AWS_PROFILE iam delete-instance-profile \
                    --region $AWS_REGION \
                    --instance-profile-name $INSTANCE_PROFILE_NAME
            )

            log_step "instance profile '$INSTANCE_PROFILE_NAME' deleted"

        else

            log_info "instance profile '$INSTANCE_PROFILE_NAME' does not exist - skipping deletion"

        fi

        ###

        log_finish "delete instance profile"
    }
}

###

if [[ ${AWS_RESOURCES_INSTANCE_PROFILE_MODULE_IMPORTED:=false} == false ]]; then

    _aws_resources_instance_profile_module

fi

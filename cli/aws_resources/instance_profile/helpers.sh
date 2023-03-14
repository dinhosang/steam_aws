#!/bin/bash


_aws_resources_instance_profile_helpers_module() {

    export AWS_RESOURCES_INSTANCE_PROFILE_HELPERS_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh


    ###


    does_profile_exist_throw_if_not(){
        aws --profile $AWS_PROFILE iam get-instance-profile \
            --region $AWS_REGION \
            --instance-profile-name $INSTANCE_PROFILE_NAME > /dev/null 2>&1
    }
}


###


if [ -z $AWS_RESOURCES_INSTANCE_PROFILE_HELPERS_MODULE_IMPORTED ]; then 

    _aws_resources_instance_profile_helpers_module

fi

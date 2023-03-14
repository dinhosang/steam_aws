#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh


##
#   FUNCTIONS
##


_create_instance_profile(){

    echo "START: Create instance profile"


    ##
    #   CREATE INSTANCE PROFILE
    ##


    {
        # try

        echo "STEP: Checking if instance profile '$INSTANCE_PROFILE_NAME' exists"

        _check_profile_exists

    } || {
        
        # catch

        echo "STEP: Creating instance profile '$INSTANCE_PROFILE_NAME'"

        local _result=$(aws --profile $AWS_PROFILE iam create-instance-profile \
            --region $AWS_REGION \
            --instance-profile-name $INSTANCE_PROFILE_NAME
        )

        local _result=$(aws --profile $AWS_PROFILE iam wait instance-profile-exists \
            --region $AWS_REGION \
            --instance-profile-name $INSTANCE_PROFILE_NAME
        )
    }

    echo "FINISH: Create instance profile"
}

_delete_instance_profile(){

    echo "START: Delete instance profile"


    ##
    #   CREATE INSTANCE PROFILE
    ##


    local profile_exists=true

    {
        # try

        echo "STEP: Checking if instance profile '$INSTANCE_PROFILE_NAME' exists"

        _check_profile_exists

    } || {
        
        # catch

        profile_exists=false
        
    }


    if [ $profile_exists == true ]; then

        echo "STEP: deleting instance profile '$INSTANCE_PROFILE_NAME'"

        local _result=$(aws --profile $AWS_PROFILE iam delete-instance-profile \
            --region $AWS_REGION \
            --instance-profile-name $INSTANCE_PROFILE_NAME
        )

        echo "STEP: instance profile '$INSTANCE_PROFILE_NAME' deleted"

    else

        echo "STEP: instance profile '$INSTANCE_PROFILE_NAME' does not exists - skipping delete"

    fi

    echo "FINISH: Delete instance profile"
}

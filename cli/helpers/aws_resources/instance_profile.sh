#!/bin/bash


_check_profile_exists(){
    aws --profile $AWS_PROFILE iam get-instance-profile \
        --region $AWS_REGION \
        --instance-profile-name $INSTANCE_PROFILE_NAME > /dev/null 2>&1
}

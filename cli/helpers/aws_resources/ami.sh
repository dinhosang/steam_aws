#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   FUNCTIONS
##


_get_active_ami_ids() {

    ##
    #   CONFIG
    ##


    local LATEST_AMI=true


    ##
    #   POSSIBLE INPUT
    ##


    if [ ${1+x} ]; then 

        LATEST_AMI=$1

    fi


    ##
    #   AMI IDs - DETERMINE WHICH TO RETRIEVE
    ##


    local query_instance_array_indexes='0'

    if ! [[ $LATEST_AMI == true ]]; then

        query_instance_array_indexes='1:'

    fi


    ##
    #   INSTANCE IDs - RETRIEVE
    ##


    local ami_ids_array=$(aws --profile $AWS_PROFILE ec2 describe-images \
        --region $AWS_REGION \
        --owners self \
        --filters "Name=tag:$TAG_KEY_PURPOSE, Values=$AMI_SNAPSHOT_TAG_PURPOSE" \
        --query "reverse(sort_by(Images,&CreationDate))[$query_instance_array_indexes].[ImageId][]"
    )

    local ami_ids=$(echo ${ami_ids_array} | jq -r '.? | join(" ")' )

    echo $ami_ids
}

_check_image_exists() {

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'IMAGE_ID not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi

    local IMAGE_ID=$1

    local result=$(aws --profile $AWS_PROFILE ec2 describe-images \
        --region $AWS_REGION \
        --image-ids $IMAGE_ID \
        --query "Images[0]"
    )

    if [[ $result == null ]]; then

        return 1

    else

        return 0

    fi

}

#!/bin/bash


_aws_resources_ami_helpers_module() {

    export AWS_RESOURCES_AMI_HELPERS_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh


    ###


    get_active_ami_ids() {

        # NOTE: if this is true it'll grab ONLY the id of the latest ami
        # NOTE: if this is false it'll grab the ids of every ami EXCEPT the latest ami
        local should_target_latest_ami=true


        ###


        if [ ${1+x} ]; then 

            should_target_latest_ami=$1

        fi


        ###


        local query_instance_array_indexes='0'

        if ! [[ $should_target_latest_ami == true ]]; then

            query_instance_array_indexes='1:'

        fi


        ###


        local -r ami_ids_array=$(aws --profile $AWS_PROFILE ec2 describe-images \
            --region $AWS_REGION \
            --owners self \
            --filters "Name=tag:$TAG_KEY_PURPOSE, Values=$AMI_SNAPSHOT_TAG_PURPOSE" \
            --query "reverse(sort_by(Images,&CreationDate))[$query_instance_array_indexes].[ImageId][]"
        )

        local -r ami_ids=$(echo "${ami_ids_array}" | jq -r '.? | join(" ")' )


        ###


        echo "$ami_ids"
    }

    does_image_exist_throw_if_not() {

        if [ -z ${1+x} ]; then 
            
            log_error 'image id not found - an image id must be passed in as the first argument'

            exit 1

        fi

        local -r IMAGE_ID=$1


        ###


        local -r result=$(aws --profile $AWS_PROFILE ec2 describe-images \
            --region $AWS_REGION \
            --image-ids "$IMAGE_ID" \
            --query "Images[0]"
        )


        ###


        if [[ $result == null ]]; then

            return 1

        else

            return 0

        fi
    }
}


###


if [ -z $AWS_RESOURCES_AMI_HELPERS_MODULE_IMPORTED ]; then 

    _aws_resources_ami_helpers_module

fi

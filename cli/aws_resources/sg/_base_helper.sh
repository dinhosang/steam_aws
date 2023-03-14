#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   FUNCTIONS
##


_get_sg_name() {

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'SG_NAME_PREFIX not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi

    ##
    #   CONFIG
    ##


    local SG_NAME_PREFIX=$1


    ##
    #   RETURN
    ##


    echo "$SG_NAME_PREFIX-sg"
}

_create_sg(){

    echo "START: Create SG"

    
    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'SG_NAME_PREFIX not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi

    if [ -z ${2+x} ]; then 
        
        printf 'SG_DESC not found - Must be passed in as the section argument to function.\n\n'

        exit 1

    fi

    if [ -z ${3+x} ]; then 
        
        printf 'IP_PROTOCOL not found - Must be passed in as the third argument to function.\n\n'

        exit 1

    fi

    if [ -z ${4+x} ]; then 
        
        printf 'FROM_PORT not found - Must be passed in as the fourth argument to function.\n\n'

        exit 1

    fi

    if [ -z ${5+x} ]; then 
        
        printf 'TO_PORT not found - Must be passed in as the fifth argument to function.\n\n'

        exit 1

    fi

    if [ -z ${6+x} ]; then 
        
        printf 'IP_V4_RANGES not found - Must be passed in as the sixth argument to function.\n\n'

        exit 1

    fi

    if [ -z ${7+x} ]; then 
        
        printf 'IP_V6_RANGES not found - Must be passed in as the seventh argument to function.\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local SG_NAME_PREFIX=$1

    local SG_DESC=$2

    local IP_PROTOCOL=$3

    local FROM_PORT=$4

    local TO_PORT=$5

    local IP_V4_RANGES=$6

    local IP_V6_RANGES=$7

    local SG_NAME=$(_get_sg_name $SG_NAME_PREFIX)


    ##
    #   CREATE SECURITY GROUP IF REQUIRED
    ##


    {
        # try

        echo "STEP: Checking if '$SG_NAME' exists"

        aws --profile $AWS_PROFILE ec2 wait security-group-exists \
            --region $AWS_REGION \
            --group-names $SG_NAME

    } || {
        
        # catch

        echo "STEP: Creating '$SG_NAME'"

        local _result=$(aws --profile $AWS_PROFILE ec2 create-security-group \
            --region $AWS_REGION \
            --group-name $SG_NAME \
            --description "$SG_DESC"
        )
    }


    ##
    # ADD IP/Port RULES
    ##


    echo "STEP: adding ip/port rules to '$SG_NAME'"

    local _result=$(aws --profile $AWS_PROFILE ec2 authorize-security-group-ingress \
        --region $AWS_REGION \
        --group-name $SG_NAME \
        --ip-permissions IpProtocol=$IP_PROTOCOL,FromPort=$FROM_PORT,ToPort=$TO_PORT,IpRanges="$IP_V4_RANGES",Ipv6Ranges="$IP_V6_RANGES"
    )


    ##
    #   DESCRIBE SECURITY GROUP
    ##


    description=$(aws --profile $AWS_PROFILE ec2 describe-security-groups \
        --region $AWS_REGION \
        --group-names $SG_NAME
    )

    description_clean=$(echo ${description} | jq -r '.' )

    echo "$description_clean"
}

_delete_sg(){

    echo "START: Delete SG"


    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'SG_NAME_PREFIX not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##


    local SG_NAME_PREFIX=$1

    local SG_NAME=$(_get_sg_name $SG_NAME_PREFIX)


    ##
    #   CHECK FOR SG
    ##


    local sg_exists=true

    {
        # try

        echo "STEP: Checking if '$SG_NAME' exists"

        aws --profile $AWS_PROFILE ec2 wait security-group-exists \
            --region $AWS_REGION \
            --group-names $SG_NAME

    } || {
        
        # catch

        echo "INFO: '$SG_NAME' security group could not be found"

        sg_exists=false
    }


    ##
    #   DELETE SG
    ##


    if [[ $sg_exists = true ]]; then

        echo "STEP: Deleting '$SG_NAME'"

        aws --profile $AWS_PROFILE ec2 delete-security-group \
                --region $AWS_REGION \
                --group-name $SG_NAME

        echo "STEP: $SG_NAME - has been deleted"

    fi

    echo "FINISH: Delete SG"

}

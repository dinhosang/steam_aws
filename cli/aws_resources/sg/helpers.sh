#!/bin/bash


_aws_resources_sg_helpers_module() {

    export AWS_RESOURCES_SG_HELPERS_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh


    ###


    get_sg_name() {

        if [ -z ${1+x} ]; then 
            
            log_error 'sg name prefix not found - it should be passed in as the first argument'

            exit 1

        fi


        ###


        local SG_NAME_PREFIX=$1


        ###


        echo "$SG_NAME_PREFIX-sg"
    }

    check_security_group_exists(){

        if [ -z ${1+x} ]; then 
            
            log_error 'sg name not found - sg name should be passed in as the first argument'

            exit 1

        fi


        ###


        local SG_NAME=$1


        ###


        aws --profile $AWS_PROFILE ec2 describe-security-groups \
            --region $AWS_REGION \
            --group-names $SG_NAME > /dev/null 2>&1
        
    }

    wait_for_security_group_to_exist() {

        if [ -z ${1+x} ]; then 
            
            log_error 'sg name not found - sg name should be passed in as the first argument'

            exit 1

        fi

        
        ###


        local SG_NAME=$1


        ###


        aws --profile $AWS_PROFILE ec2 wait security-group-exists \
            --region $AWS_REGION \
            --group-names $SG_NAME > /dev/null 2>&1
    }

    create_sg(){

        log_start "create sg"


        ###


        if [ -z ${1+x} ]; then 
            
            log_error 'SG_NAME_PREFIX not found - Must be passed in as first argument to function.\n\n'

            exit 1

        fi

        if [ -z ${2+x} ]; then 
            
            log_error 'sg description not found - should be passed in as the second argument to function'

            exit 1

        fi

        if [ -z ${3+x} ]; then 
            
            log_error 'ip protocol not found - should be passed in as the third argument to function'

            exit 1

        fi

        if [ -z ${4+x} ]; then 
            
            log_error "'from port' not found - should be passed in as the fourth argument to function"

            exit 1

        fi

        if [ -z ${5+x} ]; then 
            
            log_error "'to port' not found - should be passed in as the fifth argument to function"

            exit 1

        fi

        if [ -z ${6+x} ]; then 
            
            log_error 'ip v4 ranges not found - should be passed in as the sixth argument to function'

            exit 1

        fi

        if [ -z ${7+x} ]; then 
            
            log_error 'ip v6 ranges not found - should be passed in as the seventh argument to function'

            exit 1

        fi


        ###


        local SG_NAME_PREFIX=$1

        local SG_DESC=$2

        local IP_PROTOCOL=$3

        local FROM_PORT=$4

        local TO_PORT=$5

        local IP_V4_RANGES=$6

        local IP_V6_RANGES=$7

        local SG_NAME=$(get_sg_name $SG_NAME_PREFIX)


        ###


        local sg_exists=true

        {
            # try

            log_step "checking if '$SG_NAME' exists"

            check_security_group_exists $SG_NAME

        } || {
            
            # catch

            sg_exists=false

        }

        if [ $sg_exists == true ]; then

            log_info "'$SG_NAME' already exists - skipping creation"

        else

            log_step "creating sg - '$SG_NAME'"

            local _result=$(aws --profile $AWS_PROFILE ec2 create-security-group \
                --region $AWS_REGION \
                --group-name $SG_NAME \
                --description "$SG_DESC"
            )

            
            ###


            local sg_created=true

            {
                # try

                log_step "checking '$SG_NAME' was created"

                wait_for_security_group_to_exist $SG_NAME

            } || {
                
                # catch

                sg_created=false

            }

            if [ $sg_created == true ]; then

                log_info "'$SG_NAME' created"

            else

                log_error "could not find '$SG_NAME'"

                exit 1

            fi

        fi


        ###


        {
            # try

            log_step "adding ip/port rules to '$SG_NAME'"

            aws --profile $AWS_PROFILE ec2 authorize-security-group-ingress \
                --region $AWS_REGION \
                --ip-permissions IpProtocol=$IP_PROTOCOL,FromPort=$FROM_PORT,ToPort=$TO_PORT,IpRanges="$IP_V4_RANGES",Ipv6Ranges="$IP_V6_RANGES" \
                --group-name $SG_NAME > /dev/null

        } || {
            
            # catch

            log_info "ip/port rules already existed on '$SG_NAME', continuing with next steps"

        }

        log_finish "create sg"
    }

    delete_sg(){

        log_start "delete sg"


        ###


        if [ -z ${1+x} ]; then 
            
            log_error 'sg name prefix not found - should be passed in as the first argument to function'

            exit 1

        fi


        ###


        local SG_NAME_PREFIX=$1

        local SG_NAME=$(get_sg_name $SG_NAME_PREFIX)


        ###


        local sg_exists=true

        {
            # try

            log_step "checking if '$SG_NAME' exists"

            check_security_group_exists $SG_NAME

        } || {
            
            # catch

            sg_exists=false
        }


        ###


        if [[ $sg_exists = true ]]; then

            log_step "deleting '$SG_NAME'"

            aws --profile $AWS_PROFILE ec2 delete-security-group \
                    --region $AWS_REGION \
                    --group-name $SG_NAME

            # douglas TODO: have check here for success of last call, only log deleted if no error
            # log_step "STEP: $SG_NAME - has been deleted"

        else

            log_info "could not find security group named '$SG_NAME' - skipping delete"

        fi


        ###


        log_finish "delete sg"
    }
}


###


if [ -z $AWS_RESOURCES_SG_HELPERS_MODULE_IMPORTED ]; then 

    _aws_resources_sg_helpers_module

fi

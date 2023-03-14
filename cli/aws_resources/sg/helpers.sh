#!/bin/bash


_aws_resources_sg_helpers_module() {

    export AWS_RESOURCES_SG_HELPERS_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh


    ###


    _add_ingress_rules_to_sg() {

        if [ -z ${1+x} ]; then

            log_error 'sg name not found - Must be passed in as first argument to function'

            exit 1

        fi

        if [ -z ${2+x} ]; then

            log_error 'ip protocol not found - should be passed in as the second argument to function'

            exit 1

        fi

        if [ -z ${3+x} ]; then

            log_error "'from port' not found - should be passed in as the third argument to function"

            exit 1

        fi

        if [ -z ${4+x} ]; then

            log_error "'to port' not found - should be passed in as the fourth argument to function"

            exit 1

        fi

        if [ -z ${5+x} ]; then

            log_error 'ip v4 ranges not found - should be passed in as the fifth argument to function'

            exit 1

        fi

        if [ -z ${6+x} ]; then

            log_error 'ip v6 ranges not found - should be passed in as the sixth argument to function'

            exit 1

        fi

        if [ -z ${7+x} ]; then

            log_error 'security group id not found - should be passed in as the seventh argument to function'

            exit 1

        fi


        ###


        local SG_NAME=$1

        local IP_PROTOCOL=$2

        local FROM_PORT=$3

        local TO_PORT=$4

        local IP_V4_RANGES=$5

        local IP_V6_RANGES=$6

        local SECURITY_GROUP_ID=$7


        ###


        {
            # try

            log_step "adding ingress ip/port rules to '$SG_NAME'"

            aws --profile $AWS_PROFILE ec2 authorize-security-group-ingress \
                --region $AWS_REGION \
                --ip-permissions IpProtocol="$IP_PROTOCOL",FromPort="$FROM_PORT",ToPort="$TO_PORT",IpRanges="$IP_V4_RANGES",Ipv6Ranges="$IP_V6_RANGES" \
                --group-name "$SG_NAME" > /dev/null

        } || {

            # catch

            log_info "ip/port INGRESS rules already existed on '$SG_NAME' - '$SECURITY_GROUP_ID', continuing with next steps"

        }
    }

    _add_egress_rules_to_sg() {

        if [ -z ${1+x} ]; then

            log_error 'sg name not found - Must be passed in as first argument to function'

            exit 1

        fi

        if [ -z ${2+x} ]; then

            log_error 'ip protocol not found - should be passed in as the second argument to function'

            exit 1

        fi

        if [ -z ${3+x} ]; then

            log_error "'from port' not found - should be passed in as the third argument to function"

            exit 1

        fi

        if [ -z ${4+x} ]; then

            log_error "'to port' not found - should be passed in as the fourth argument to function"

            exit 1

        fi

        if [ -z ${5+x} ]; then

            log_error 'ip v4 ranges not found - should be passed in as the fifth argument to function'

            exit 1

        fi

        if [ -z ${6+x} ]; then

            log_error 'ip v6 ranges not found - should be passed in as the sixth argument to function'

            exit 1

        fi

        if [ -z ${7+x} ]; then

            log_error 'security group id not found - should be passed in as the seventh argument to function'

            exit 1

        fi


        ###


        local SG_NAME=$1

        local IP_PROTOCOL=$2

        local FROM_PORT=$3

        local TO_PORT=$4

        local IP_V4_RANGES=$5

        local IP_V6_RANGES=$6

        local SECURITY_GROUP_ID=$7


        ###


        {
            # try

            log_step "adding egress ip/port rules to '$SG_NAME'"

            aws --profile $AWS_PROFILE ec2 authorize-security-group-egress \
                --region $AWS_REGION \
                --ip-permissions IpProtocol="$IP_PROTOCOL",FromPort="$FROM_PORT",ToPort="$TO_PORT",IpRanges="$IP_V4_RANGES",Ipv6Ranges="$IP_V6_RANGES" \
                --group-id "$SECURITY_GROUP_ID" > /dev/null

        } || {

            # catch

            log_info "ip/port EGRESS rules already existed on '$SG_NAME' - '$SECURITY_GROUP_ID', continuing with next steps"

        }
    }

     _remove_default_allow_all_egress_rules_from_sg() {

        if [ -z ${1+x} ]; then

            log_error 'sg name not found - Must be passed in as first argument to function'

            exit 1

        fi

        if [ -z ${2+x} ]; then

            log_error 'security group id not found - should be passed in as the second argument to function'

            exit 1

        fi


        ###


        local SG_NAME=$1

        local SECURITY_GROUP_ID=$2


        ###


        {
            # try

            log_step "removing the default egress vpc rule from '$SG_NAME' - '$security_group_id'"

            aws --profile $AWS_PROFILE ec2 revoke-security-group-egress \
                --region $AWS_REGION \
                --ip-permissions '[{"IpProtocol":"-1","FromPort":-1,"ToPort":-1,"IpRanges":[{"CidrIp":"0.0.0.0/0"}] }]' \
                --group-id "$security_group_id" > /dev/null

        } || {

            # catch

            log_warn "issue removing the default egress rule from '$SG_NAME' - '$security_group_id'"

        }
    }

    _check_security_group_exists(){

        if [ -z ${1+x} ]; then 
            
            log_error 'sg name not found - sg name should be passed in as the first argument'

            exit 1

        fi


        ###


        local SG_NAME=$1


        ###


        aws --profile $AWS_PROFILE ec2 describe-security-groups \
            --region $AWS_REGION \
            --group-names "$SG_NAME" > /dev/null 2>&1
        
    }

    _wait_for_security_group_to_exist() {

        if [ -z ${1+x} ]; then 
            
            log_error 'sg name not found - sg name should be passed in as the first argument'

            exit 1

        fi

        
        ###


        local SG_NAME=$1


        ###


        aws --profile $AWS_PROFILE ec2 wait security-group-exists \
            --region $AWS_REGION \
            --group-names "$SG_NAME" > /dev/null 2>&1
    }

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

    create_sg(){

        log_start "create sg"


        ###


        if [ -z ${1+x} ]; then 
            
            log_error 'SG_NAME_PREFIX not found - Must be passed in as first argument to function'

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


        local -r SG_NAME_PREFIX=$1

        local -r SG_DESC=$2

        local -r IP_PROTOCOL=$3

        local -r FROM_PORT=$4

        local -r TO_PORT=$5

        local -r IP_V4_RANGES=$6

        local -r IP_V6_RANGES=$7

        local -r SG_NAME=$(get_sg_name "$SG_NAME_PREFIX")


        ###


        local sg_exists=true

        {
            # try

            log_step "checking if '$SG_NAME' exists"

            _check_security_group_exists "$SG_NAME"

        } || {
            
            # catch

            sg_exists=false

        }

        if [ $sg_exists == true ]; then

            log_info "'$SG_NAME' already exists - skipping creation"

            return 0

        else

            log_step "creating sg - '$SG_NAME'"

            local -r security_group_id_raw=$(aws --profile $AWS_PROFILE ec2 create-security-group \
                --region $AWS_REGION \
                --group-name "$SG_NAME" \
                --description "$SG_DESC" \
                --query "GroupId"
            )

            local -r security_group_id=$(echo "$security_group_id_raw" | jq -r '.')

            
            ###


            local sg_created=true

            {
                # try

                log_step "checking '$SG_NAME' was created"

                _wait_for_security_group_to_exist "$SG_NAME"

            } || {
                
                # catch

                sg_created=false

            }

            if [ $sg_created == true ]; then

                log_info "'$SG_NAME' with id '$security_group_id' created"

            else

                log_error "could not find '$SG_NAME'"

                exit 1

            fi

        fi


        ###


        _add_ingress_rules_to_sg "$SG_NAME" \
            "$IP_PROTOCOL" \
            "$FROM_PORT" \
            "$TO_PORT" \
            "$IP_V4_RANGES" \
            "$IP_V6_RANGES" \
            "$security_group_id"


        ###


        ###
        # NOTE:
        #       -   not required unless making use of _remove_default_allow_all_egress_rules_from_sg
        #       -   would likely need to add a lot more hard-coded values for steam etc.
        ###

        # _add_egress_rules_to_sg $SG_NAME \
        #     $IP_PROTOCOL \
        #     $FROM_PORT \
        #     $TO_PORT \
        #     "$IP_V4_RANGES" \
        #     "$IP_V6_RANGES" \
        #     $security_group_id


        ###


        ###
        # NOTE:
        #       -   the below removes the default all egress rule from the sgs
        #       -   but steam requires some ports/ips ranges to be open on egress, for logging in etc
        #       -   would need to figure out what ports steam and other apps would need to use this
        #       -   if using this would also need to update and use _add_egress_rules_to_sg
        ###

        # _remove_default_allow_all_egress_rules_from_sg $SG_NAME $security_group_id


        ###


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


        local -r SG_NAME_PREFIX=$1

        local -r SG_NAME=$(get_sg_name "$SG_NAME_PREFIX")


        ###


        local sg_exists=true

        {
            # try

            log_step "checking if '$SG_NAME' exists"

            _check_security_group_exists "$SG_NAME"

        } || {
            
            # catch

            sg_exists=false
        }


        ###


        if [[ $sg_exists = true ]]; then

            log_step "deleting '$SG_NAME'"

            aws --profile $AWS_PROFILE ec2 delete-security-group \
                    --region $AWS_REGION \
                    --group-name "$SG_NAME"

        else

            log_info "could not find security group named '$SG_NAME' - skipping deletion"

        fi


        ###


        log_finish "delete sg"
    }
}


###


if [ -z $AWS_RESOURCES_SG_HELPERS_MODULE_IMPORTED ]; then 

    _aws_resources_sg_helpers_module

fi

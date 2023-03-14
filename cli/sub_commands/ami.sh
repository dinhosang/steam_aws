#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh

source ./cli/aws_resources/ami/index.sh


##
#   FUNCTIONS
##


_create_ami() {

    echo "START: create AMI"

    _create_ami_via_packer

    echo "FINISH: create AMI"
}

_delete_all_but_most_recent_ami() {
    
    echo "START: prune AMIs"
    

    ##
    #   AMIs - RETRIEVE IDs
    ##


    local ami_ids=($(_get_active_ami_ids false))


    if [ -z "$ami_ids" ]; then

        echo "INFO: No additional amis found"

    else

        ##
        #   AMIs - DELETE
        ##


       _delete_ami ${ami_ids[*]}

    fi

    echo "FINISH: prune AMIs"
}

_delete_most_recent_ami() {
    
    echo "START: delete most recent AMI"
    

    ##
    #   AMIs - RETRIEVE IDs
    ##


    local ami_ids=($(_get_active_ami_ids true))


    if [ -z "$ami_ids" ]; then

        echo "INFO: No ami found"

    else

        ##
        #   AMIs - DELETE
        ##


       _delete_ami ${ami_ids[*]}

    fi

    echo "FINISH: delete most recent AMI"
}

_create_ami_from_latest_instance() {
    
    echo "START: create AMI from latest instance"
    

    ##
    #   LATEST INSTANCE - GRAB ID
    ##


    local latest_instance_id=$(_get_running_instance_ids true)


    ##
    #   LATEST INSTANCE - CHECK ID WAS RETURNED
    ##


    if [ -z "$latest_instance_id" ]; then

        echo "STEP: no running instance found to create new AMI from"

    else

        echo "STEP: latest running instance found - '$latest_instance_id'"

        _create_ami_via_aws_cli_and_instance_id $latest_instance_id

    fi

    echo "FINISH: create AMI from latest instance"
}

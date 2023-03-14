#!/bin/bash


_subcommands_instance_module() {

    export SUBCOMMANDS_INSTANCE_MODULE_IMPORTED=true


    ###


    source ./cli/aws_resources/ec2/helpers.sh

    source ./cli/aws_resources/ami/index.sh
    source ./cli/aws_resources/ec2/index.sh
    source ./cli/aws_resources/instance_profile/index.sh
    source ./cli/aws_resources/sg/index.sh


    ###


    create_profile_sgs_instance(){

        log_start "creating profile, sgs, and instance"

        
        ###


        create_instance_profile


        ###


        create_aws_connect_sg
        create_rdp_sg


        ###


        create_ec2


        ###


        log_finish "creating profile, sgs, and instance"
    }

    delete_all_but_most_recent_instance() {

        log_start "prune instances"

        
        ###


        local instance_ids=($(get_running_instance_ids false))


        ###


        if [ -z "$instance_ids" ]; then

            log_info "no additional instances found running - skipping deletion"

        else

            delete_ec2 ${instance_ids[*]}

        fi


        ###


        log_finish "prune instances"
    }

    delete_profile_sgs_instance(){

        log_start "deleting profile, sgs, and most recent instance"


        ###


        local instance_id=($(get_running_instance_ids true))


        ###


        if [ -z "$instance_id" ]; then

            log_info "no instances found running - skipping deletion"

        else

            delete_ec2 ${instance_id[*]}

        fi


       ###


        delete_aws_connect_sg
        delete_rdp_sg


        ###


        delete_instance_profile


        ###


        log_finish "deleting profile, sgs, and most recent instance"
    }
}


###


if [ -z $SUBCOMMANDS_INSTANCE_MODULE_IMPORTED ]; then 

    _subcommands_instance_module

fi

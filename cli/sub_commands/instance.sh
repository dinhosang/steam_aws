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

    create_profile_sgs_instance() {

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

        local instance_ids

        read -r -a instance_ids <<<"$(get_running_instance_ids false)"

        ###

        if [ -z "${instance_ids[0]:-}" ]; then

            log_info "no additional instances found running - skipping deletion"

        else

            delete_ec2 "${instance_ids[*]}"

        fi

        ###

        log_finish "prune instances"
    }

    delete_profile_sgs_instance() {

        log_start "deleting most recent instance, and the sgs / instance profile"

        ###

        local instance_id

        read -r -a instance_id <<<"$(get_running_instance_ids true)"

        ###

        if [ -z "${instance_id[0]:-}" ]; then

            log_info "no instances found running - skipping deletion"

        else

            delete_ec2 "${instance_id[*]}"

        fi

        ###

        delete_aws_connect_sg
        delete_rdp_sg

        ###

        delete_instance_profile

        ###

        log_finish "deleting most recent instance, and the sgs / instance profile"
    }
}

###

if [[ ${SUBCOMMANDS_INSTANCE_MODULE_IMPORTED:=false} == false ]]; then

    _subcommands_instance_module

fi

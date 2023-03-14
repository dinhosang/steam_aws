#!/bin/bash

_subcommands_ami_module() {

    export SUBCOMMANDS_AMI_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    source ./cli/helpers/index.sh
    source ./cli/aws_resources/ami/helpers.sh
    source ./cli/aws_resources/ec2/helpers.sh

    source ./cli/aws_resources/ami/index.sh

    ###

    create_ami() {

        log_start "create AMI"

        ###

        create_ami_via_packer

        ###

        log_finish "create AMI"
    }

    delete_all_but_most_recent_ami() {

        log_start "prune AMIs"

        ###

        local ami_ids

        read -r -a ami_ids <<<"$(get_active_ami_ids false)"

        ###

        if [ -z "${ami_ids[0]}" ]; then

            log_info "no additional AMIs found - skipping deletion"

        else

            delete_ami "${ami_ids[*]}"

        fi

        ###

        log_finish "prune AMIs"
    }

    delete_most_recent_ami() {

        log_start "delete most recent AMI"

        ###

        local ami_ids

        read -r -a ami_ids <<<"$(get_active_ami_ids true)"

        ###

        if [ -z "${ami_ids[0]}" ]; then

            log_info "no ami found - skipping deletion"

        else

            delete_ami "${ami_ids[*]}"

        fi

        ###

        log_finish "delete most recent AMI"
    }

    create_ami_from_latest_instance() {

        log_start "create AMI from latest instance"

        ###

        local -r latest_instance_id=$(get_running_instance_ids true)

        ###

        if [ -z "$latest_instance_id" ]; then

            log_info "no running instance found - skipping ami creation"

        else

            log_step "instance id - '$latest_instance_id'"

            create_ami_via_aws_cli_and_instance_id "$latest_instance_id"

        fi

        ###

        log_finish "create AMI from latest instance"
    }
}

###

if [ -z $SUBCOMMANDS_AMI_MODULE_IMPORTED ]; then

    _subcommands_ami_module

fi

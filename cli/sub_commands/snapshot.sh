#!/bin/bash

_subcommands_snapshot_module() {

    export SUBCOMMANDS_SNAPSHOT_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    source ./cli/helpers/index.sh
    source ./cli/aws_resources/snapshot/helpers.sh

    source ./cli/aws_resources/snapshot/index.sh

    ###

    delete_all_but_most_recent_snapshot() {

        log_start "prune volume snapshots"

        ####

        local snapshot_ids

        read -r -a snapshot_ids <<<"$(get_volume_snapshot_ids false)"

        ###

        if [ -z "${snapshot_ids[0]}" ]; then

            log_info "no additional snapshots found - skipping deletion"

        else

            delete_snapshot "${snapshot_ids[*]}"

        fi

        ###

        log_finish "prune volume snapshots"
    }

    delete_most_recent_snapshot() {

        log_start "delete most recent volume snapshot"

        ###

        local snapshot_ids

        read -r -a snapshot_ids <<<"$(get_volume_snapshot_ids true)"

        ###

        if [ -z "${snapshot_ids[0]}" ]; then

            log_info "no snapshot found - skipping deletion"

        else

            delete_snapshot "${snapshot_ids[*]}"

        fi

        ###

        log_finish "delete most recent volume snapshot"
    }
}

###

if [ -z $SUBCOMMANDS_SNAPSHOT_MODULE_IMPORTED ]; then

    _subcommands_snapshot_module

fi

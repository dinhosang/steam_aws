#!/bin/bash

_cli_index_module() {

    export CLI_INDEX_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    source ./cli/helpers/index.sh

    source ./cli/sub_commands/index.sh

    ###

    handle_ami() {

        local USER_SUB_COMMAND=$1

        local USER_FLAGS

        read -r -a USER_FLAGS <<<"${@:2}"

        ###

        if ! (is_in_list "$USER_SUB_COMMAND" "${AMI_SUB_COMMANDS[@]}"); then

            print_help_and_quit $AMI 1

        fi

        ###

        if [ $HELP == "$USER_SUB_COMMAND" ]; then

            print_help_and_quit $AMI 0

        fi

        ###

        handle_flags

        ###

        if [ $CREATE == "$USER_SUB_COMMAND" ]; then

            create_ami

        elif [ $DELETE == "$USER_SUB_COMMAND" ]; then

            delete_most_recent_ami

        elif [ $UPDATE == "$USER_SUB_COMMAND" ]; then

            create_ami_from_latest_instance

        elif [ $PRUNE == "$USER_SUB_COMMAND" ]; then

            delete_all_but_most_recent_ami

        fi
    }

    handle_instance() {

        local -r USER_SUB_COMMAND=$1

        local USER_FLAGS

        read -r -a USER_FLAGS <<<"${@:2}"

        ###

        if ! (is_in_list "$USER_SUB_COMMAND" "${INSTANCE_SUB_COMMANDS[@]}"); then

            print_help_and_quit $INSTANCE 1

        fi

        ###

        if [ $HELP == "$USER_SUB_COMMAND" ]; then

            print_help_and_quit $INSTANCE 0

        fi

        ###

        handle_flags

        ###

        if [ $CREATE == "$USER_SUB_COMMAND" ]; then

            create_profile_sgs_instance

        elif [ $DELETE == "$USER_SUB_COMMAND" ]; then

            delete_profile_sgs_instance

        elif [ $PRUNE == "$USER_SUB_COMMAND" ]; then

            delete_all_but_most_recent_instance

        fi
    }

    handle_snapshot() {

        local USER_SUB_COMMAND=$1

        local USER_FLAGS

        read -r -a USER_FLAGS <<<"${@:2}"

        ###

        if ! (is_in_list "$USER_SUB_COMMAND" "${SNAPSHOT_SUB_COMMANDS[@]}"); then

            print_help_and_quit $SNAPSHOT 1

        fi

        ###

        if [ $HELP == "$USER_SUB_COMMAND" ]; then

            print_help_and_quit $SNAPSHOT 0

        fi

        ###

        handle_flags

        ###

        if [ $DELETE == "$USER_SUB_COMMAND" ]; then

            delete_most_recent_snapshot

        elif [ $PRUNE == "$USER_SUB_COMMAND" ]; then

            delete_all_but_most_recent_snapshot

        fi
    }
}

###

if [ -z $CLI_INDEX_MODULE_IMPORTED ]; then

    _cli_index_module

fi

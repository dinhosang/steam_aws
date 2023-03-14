#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/helpers/index.sh

source ./cli/sub_commands/index.sh


##
#   FUNCTIONS
##


handle_ami() {
    
    ##
    #   HANDLE INPUT - technically not required due to local variables in main() as this shares same context
    ##


    local USER_SUB_COMMAND=$1
    
    local USER_FLAGS=(${@:2})


    ##
    #   RUN
    ##


    if ! (is_in_list $USER_SUB_COMMAND "${AMI_SUB_COMMANDS[@]}"); then

        print_help_and_quit $AMI 1

    fi


    if [ $CREATE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _create_ami

    elif [ $DELETE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_most_recent_ami

    elif [ $UPDATE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _create_ami_from_latest_instance

    elif [ $PRUNE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_all_but_most_recent_ami

    else

        print_help_and_quit $AMI 0

    fi
}

handle_instance() {

    ##
    #   HANDLE INPUT - technically not required due to local variables in main() as this shares same context
    ##


    local USER_SUB_COMMAND=$1
    
    local USER_FLAGS=(${@:2})


    ##
    #   RUN
    ##


    if ! (is_in_list $USER_SUB_COMMAND "${INSTANCE_SUB_COMMANDS[@]}"); then

        print_help_and_quit $INSTANCE 1

    fi


    if [ $CREATE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _create_instance_and_related_resources

    elif [ $DELETE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_instance_and_related_resources

    elif [ $PRUNE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_all_but_most_recent_instance

    else

        print_help_and_quit $INSTANCE 0

    fi
}

handle_snapshot() {
    
    ##
    #   HANDLE INPUT - technically not required due to local variables in main() as this shares same context
    ##


    local USER_SUB_COMMAND=$1
    
    local USER_FLAGS=(${@:2})


    ##
    #   RUN
    ##


    if ! (is_in_list $USER_SUB_COMMAND "${SNAPSHOT_SUB_COMMANDS[@]}"); then

        print_help_and_quit $SNAPSHOT 1

    fi


    if [ $DELETE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_most_recent_snapshot

    elif [ $PRUNE == $USER_SUB_COMMAND ]; then

        _handle_flags

        _delete_all_but_most_recent_snapshot

    else

        print_help_and_quit $SNAPSHOT 0

    fi
}

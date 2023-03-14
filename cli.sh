#!/bin/bash

set -eu

###

source ./cli/index.sh

###

main() {

    local -r USER_COMMAND="${1-}"
    local -r USER_SUB_COMMAND="${2-}"

    local USER_FLAGS
    read -r -a USER_FLAGS <<<"${@:3}"

    ###

    if [ -z ${1+x} ]; then

        print_help_and_quit $HELP 1

    fi

    if ! (is_in_list "$USER_COMMAND" "${COMMANDS[@]}"); then

        print_help_and_quit $HELP 1

    fi

    ###

    if [ $AMI == "$USER_COMMAND" ]; then

        handle_ami "$USER_SUB_COMMAND" "${USER_FLAGS[@]}"

    elif [ $INSTANCE == "$USER_COMMAND" ]; then

        handle_instance "$USER_SUB_COMMAND" "${USER_FLAGS[@]}"

    elif [ $SNAPSHOT == "$USER_COMMAND" ]; then

        handle_snapshot "$USER_SUB_COMMAND" "${USER_FLAGS[@]}"

    else

        print_help_and_quit $HELP 0

    fi
}

###

echo -e '\n'

###

main "$@"

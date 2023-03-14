#!/bin/bash


##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##


source ./tools/common/_config.sh

source ./tools/common/_helpers.sh


###

_tools_docker_tooling_module() {

    export TOOLS_DOCKER_TOOLING_EXPORTED=true


    ###


    build_tooling_image() {

        docker build -t $STEAM_AWS_TOOLING_IMAGE -f ./tools/docker_tooling/Dockerfile .
    }


    ###


    run_shellcheck_tooling() {

        local -r cli_dir=$(pwd)

        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            $STEAM_AWS_TOOLING_IMAGE "find /src -type f \( -name '*.sh' -o -path '/src/packer/scripts/startup/*' -name '*.txt' \) | xargs shellcheck -a -x -f tty --norc -s bash -S style"
    }

    run_fmt_check_tooling() {

        local -r cli_dir=$(pwd)

        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            $STEAM_AWS_TOOLING_IMAGE "shfmt -d -i 4 ."
    }

    run_fmt_fix_tooling() {

        local -r cli_dir=$(pwd)

        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            $STEAM_AWS_TOOLING_IMAGE "shfmt -w -i 4 ."
    }

    run_controller() {

        local -r SUB_COMMAND="$1"

        if [ -z "$SUB_COMMAND" ]; then

            echo "ERROR: please pass in one of the following sub commands: [${ACCEPTED_SUB_COMMANDS[*]}]"

            exit 1

        fi


        ###


        if ! (_is_in_list "$SUB_COMMAND" "${ACCEPTED_SUB_COMMANDS[@]}"); then

            echo "please enter one of: [${ACCEPTED_SUB_COMMANDS[*]}]"

            exit 1

        fi


        ###


        if [ $LINT == "$SUB_COMMAND" ]; then

            run_shellcheck_tooling

        elif [ $FORMAT == "$SUB_COMMAND" ]; then

            run_fmt_check_tooling

        else

            run_fmt_fix_tooling

        fi
    }

    ###

    steam_aws_docker_tooling_main() {

        local -r COMMAND=$1

        if [ -z "$COMMAND" ]; then

            echo "please enter one of: [${ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if ! (_is_in_list "$COMMAND" "${ACCEPTED_COMMANDS[@]}"); then

            echo "please enter one of: [${ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if [ $BUILD == "$COMMAND" ]; then

            build_tooling_image

        else

            local -r SUB_COMMAND=$2

            run_controller "$SUB_COMMAND"

        fi
    }
}

###

if [ -z $TOOLS_DOCKER_TOOLING_EXPORTED ]; then

    _tools_docker_tooling_module

fi

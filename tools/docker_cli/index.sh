#!/bin/bash

##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##

source ./tools/docker_cli/_config.sh
source ./tools/common/_helpers.sh

_tools_docker_cli_module() {

    export TOOLS_DOCKER_CLI_EXPORTED=true

    ###

    build_steam_aws_runner_image() {

        docker build \
            -t ${STEAM_AWS_RUNNER_IMAGE}:latest \
            -f ./tools/docker_cli/Dockerfile \
            --rm \
            --build-arg USER_NAME_PROVIDED=$STEAM_AWS_RUNNER_CONTAINER_USER \
            .
    }

    run_steam_aws_runner() {

        local cli_cmd="${*}"

        ###

        if [ -z "$cli_cmd" ]; then

            cli_cmd=help

        fi

        ###

        local -r cli_dir=$(pwd)

        local -r aws_config_dir=~/.aws

        local -r container_aws_config_dir=/home/$STEAM_AWS_RUNNER_CONTAINER_USER/.aws

        ###

        docker run \
            --network host \
            --rm \
            -v "$cli_dir":/home/${STEAM_AWS_RUNNER_CONTAINER_USER}/src \
            -v $aws_config_dir:$container_aws_config_dir \
            $STEAM_AWS_RUNNER_IMAGE ${cli_cmd}
    }

    ###

    steam_aws_docker_cli_main() {

        if [ -z ${1+x} ]; then

            echo "please enter one of: [${DOCKER_CLI_ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        local -r STEAM_AWS_CLI_BUILD_SCRIPT_ACTION=$1

        ###

        if ! (_is_in_list "$STEAM_AWS_CLI_BUILD_SCRIPT_ACTION" "${DOCKER_CLI_ACCEPTED_COMMANDS[@]}"); then

            echo "please enter one of: [${DOCKER_CLI_ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if [ $BUILD == "$STEAM_AWS_CLI_BUILD_SCRIPT_ACTION" ]; then

            build_steam_aws_runner_image

        else

            local RUNNER_CMDS

            read -r -a RUNNER_CMDS <<<"${@:2}"

            run_steam_aws_runner "${RUNNER_CMDS[@]:-}"

        fi
    }
}

###

if [[ ${TOOLS_DOCKER_CLI_EXPORTED:=false} == false ]]; then

    _tools_docker_cli_module

fi

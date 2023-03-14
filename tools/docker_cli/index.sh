#!/bin/bash


##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##


_tools_docker_cli_module() {

    export TOOLS_DOCKER_CLI_EXPORTED=true


    ###


    source ./tools/common/_config.sh
    source ./tools/common/_helpers.sh


    ###


    build_steam_aws_runner_image() {

        docker build \
            -t $STEAM_AWS_RUNNER_IMAGE \
            -f ./tools/docker_cli/Dockerfile \
            --build-arg USER_NAME_PROVIDED=$STEAM_AWS_RUNNER_CONTAINER_USER \
            .
    }

    run_steam_aws_runner() {

        local cli_cmd="$@"


        ###


        if [ -z "$cli_cmd" ]; then 
                
            cli_cmd=help

        fi


        ###


        local cli_dir=$(pwd)

        local aws_config_dir=~/.aws

        local container_aws_config_dir=/home/$STEAM_AWS_RUNNER_CONTAINER_USER/.aws


        ###


        docker run \
            --network host \
            --rm \
            -v $cli_dir:/home/${STEAM_AWS_RUNNER_CONTAINER_USER}/src \
            -v $aws_config_dir:$container_aws_config_dir \
            $STEAM_AWS_RUNNER_IMAGE $cli_cmd
    }


    ###


    steam_aws_docker_cli_main() {

        local BUILD='build'
        local RUN='run'

        local ACCEPTED_ACTIONS=($BUILD $RUN)


        ###


        if [ -z ${1+x} ]; then

            echo "please enter one of: [${ACCEPTED_ACTIONS[@]}]"

            exit 1

        fi

        local STEAM_AWS_CLI_BUILD_SCRIPT_ACTION=$1


        ###


        if ! (_is_in_list $STEAM_AWS_CLI_BUILD_SCRIPT_ACTION "${ACCEPTED_ACTIONS[@]}"); then

            echo "please enter one of: [${ACCEPTED_ACTIONS[@]}]"

            exit 1

        fi


        ###


        if [ $STEAM_AWS_CLI_BUILD_SCRIPT_ACTION == $BUILD ]; then

            build_steam_aws_runner_image

        else

            local RUNNER_CMDS="${@:2}"

            run_steam_aws_runner $RUNNER_CMDS

        fi
    }
}


###


if [ -z $TOOLS_DOCKER_CLI_EXPORTED ]; then 

    _tools_docker_cli_module

fi

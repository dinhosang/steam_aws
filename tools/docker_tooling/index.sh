#!/bin/bash


##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##


_tools_docker_tooling_module() {

    export TOOLS_DOCKER_TOOLING_EXPORTED=true


    ###


    source ./tools/common/_config.sh
    source ./tools/common/_helpers.sh


    ###


    build_tooling_image() {

        docker build -t $STEAM_AWS_TOOLING_IMAGE -f ./tools/docker_tooling/Dockerfile .
    }

    run_shellcheck_tooling() {

        local -r cli_dir=$(pwd)

        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            $STEAM_AWS_TOOLING_IMAGE "shellcheck -a -x -f tty --norc -s bash -S style *.sh"
    }


    ###


    steam_aws_docker_tooling_main() {

        local BUILD='build'
        local RUN='run'

        local ACCEPTED_ACTIONS=("$BUILD" "$RUN")


        ###


        if [ -z ${1+x} ]; then

            echo "please enter one of: [${ACCEPTED_ACTIONS[*]}]"

            exit 1

        fi

        local TOOLING_BUILD_SCRIPT_ACTION=$1


        ###


        if ! (_is_in_list "$TOOLING_BUILD_SCRIPT_ACTION" "${ACCEPTED_ACTIONS[@]}"); then

            echo "please enter one of: [${ACCEPTED_ACTIONS[*]}]"

            exit 1

        fi


        ###


        if [ $BUILD == "$TOOLING_BUILD_SCRIPT_ACTION"  ]; then

            build_tooling_image

        else

            run_shellcheck_tooling

        fi
    }
}


###


if [ -z $TOOLS_DOCKER_TOOLING_EXPORTED ]; then 

    _tools_docker_tooling_module

fi

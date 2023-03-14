#!/bin/bash

##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##

source ./tools/docker_tooling/_config.sh
source ./tools/common/_helpers.sh

###

_tools_docker_tooling_module() {

    export TOOLS_DOCKER_TOOLING_EXPORTED=true

    ###

    build_tooling_image() {

        docker build \
            -t ${STEAM_AWS_TOOLING_IMAGE}:latest \
            -f ./tools/docker_tooling/Dockerfile \
            --rm \
            .
    }

    ###

    run_lint_shellcheck_tooling() {

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
            $STEAM_AWS_TOOLING_IMAGE "shfmt -d ."
    }

    run_fmt_fix_tooling() {

        local -r cli_dir=$(pwd)

        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            $STEAM_AWS_TOOLING_IMAGE "shfmt -w ."
    }

    run_test_shellspec_tooling() {

        local -r cli_dir=$(pwd)

        local -r docker_overrides="${1:-}"

        local -r shellspec_overrides=("${@:2}")

        # shellcheck disable=SC2086
        docker run \
            --rm \
            -v "$cli_dir":/src \
            -t \
            ${docker_overrides} \
            $STEAM_AWS_TOOLING_IMAGE "shellspec ${shellspec_overrides[*]:-}"
    }

    run_test_ci_shellspec_tooling() {
        run_test_shellspec_tooling '-u=root'
    }

    run_test_no_cov_shellspec_tooling() {
        run_test_shellspec_tooling "" "--no-kcov"
    }

    run_controller() {

        local -r SUB_COMMAND="$1"

        if [ -z "$SUB_COMMAND" ]; then

            echo "ERROR: please pass in one of the following sub commands: [${DOCKER_TOOLING_ACCEPTED_SUB_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if ! (_is_in_list "$SUB_COMMAND" "${DOCKER_TOOLING_ACCEPTED_SUB_COMMANDS[@]}"); then

            echo "please enter one of: [${DOCKER_TOOLING_ACCEPTED_SUB_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if [ $TEST == "$SUB_COMMAND" ]; then

            run_test_shellspec_tooling

        elif [ $TEST_CI == "$SUB_COMMAND" ]; then

            run_test_ci_shellspec_tooling

        elif [ $TEST_NO_COV == "$SUB_COMMAND" ]; then

            run_test_no_cov_shellspec_tooling

        elif [ $LINT == "$SUB_COMMAND" ]; then

            run_lint_shellcheck_tooling

        elif [ $FORMAT == "$SUB_COMMAND" ]; then

            run_fmt_check_tooling

        else

            run_fmt_fix_tooling

        fi
    }

    ###

    steam_aws_docker_tooling_main() {

        local -r COMMAND="${1:-}"

        if [ -z "$COMMAND" ]; then

            echo "please enter one of: [${DOCKER_TOOLING_ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if ! (_is_in_list "$COMMAND" "${DOCKER_TOOLING_ACCEPTED_COMMANDS[@]}"); then

            echo "please enter one of: [${DOCKER_TOOLING_ACCEPTED_COMMANDS[*]}]"

            exit 1

        fi

        ###

        if [ $BUILD == "$COMMAND" ]; then

            build_tooling_image

        else

            local -r SUB_COMMAND="${2:-}"

            run_controller "$SUB_COMMAND"

        fi
    }
}

###

if [[ ${TOOLS_DOCKER_TOOLING_EXPORTED:=false} == false ]]; then

    _tools_docker_tooling_module

fi

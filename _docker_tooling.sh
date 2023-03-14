#!/bin/bash

##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##

source ./tools/docker_tooling/index.sh

##
#   USAGE GUIDE:
#
#
#   ./docker_tooling.sh build
#
#       -   will build the tooling image
#
#
#   ./docker_tooling.sh run <sub_command>
#
#       -   will run one of either: linting, formatting, formatting-auto-fix
#
#
##
#
#   ./docker_tooling.sh run lint
#
#       -   will run the shellcheck linter to report on possible syntax errors / dangerous code
#
#   ./docker_tooling.sh run lint
#
#       -   will run the shfmt tool to report on style mistakes
#
#   ./docker_tooling.sh run lint:fix
#
#       -   will run the shfmt tool and auto update files with the recommended changes
#
##

steam_aws_docker_tooling_main "$@"

#!/bin/bash

set -eu

##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##

source ./tools/docker_cli/index.sh

##
#   USAGE GUIDE:
#
#
#   ./docker_cli.sh build
#
#       -   will build the runner image
#
#   ./docker_cli.sh run
#
#       -   will display the cli help text, the commands, sub-commands, flags can also be passed in
#           -   exmaple: './docker_cli.sh run ami create' will start the ami create process
#
##

steam_aws_docker_cli_main "$@"

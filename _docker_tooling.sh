#!/bin/bash

set -eu

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
#       -   will run one of either:
#
#               test, test with coverage, test for ci, linting, formatting, formatting with auto-fix
#
#           -   see below for further details
#
##
#
#   ./docker_tooling.sh run test
#
#       -   will run the unit tests via shellspec with coverage
#
#   ./docker_tooling.sh run test:nocov
#
#       -   will run the unit tests via shellspec without coverage (much faster than with)
#
#   ./docker_tooling.sh run test:ci
#
#       -   will run the unit tests via shellspec as root to allow for coverage checks in ci
#
#   ./docker_tooling.sh run lint
#
#       -   will run the shellcheck linter to report on possible syntax errors / dangerous code
#
#   ./docker_tooling.sh run fmt
#
#       -   will run the shfmt tool to report on style mistakes
#
#   ./docker_tooling.sh run fmt:fix
#
#       -   will run the shfmt tool and auto update files with the recommended changes
#
##

steam_aws_docker_tooling_main "$@"

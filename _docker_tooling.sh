#!/bin/bash


##
#   NOTE:
#       -   all commands must be run at the root of steam_aws directory
#
##


source ./tools/docker_tooling/index.sh


###


##
#   USAGE GUIDE:
#
#
#   ./docker_tooling.sh build 
#
#       -   will build the tooling image
#
#
#   ./docker_tooling.sh run 
#
#       -   will run the shellcheck tool, reporting on errors/style issues
#
#
## 


steam_aws_docker_tooling_main "$@"

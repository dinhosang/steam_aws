#!/bin/bash

###

export BUILD='build'
export RUN='run'

export LINT='lint'
export FORMAT='fmt'
export FORMAT_FIX='fmt:fix'

export ACCEPTED_COMMANDS=("$BUILD" "$RUN")
export ACCEPTED_SUB_COMMANDS=("$LINT" "$FORMAT" "$FORMAT_FIX")

###

export STEAM_AWS_RUNNER_IMAGE=steam_aws_runner
export STEAM_AWS_RUNNER_CONTAINER_USER=$STEAM_AWS_RUNNER_IMAGE

###

export STEAM_AWS_TOOLING_IMAGE=steam_aws_tooling

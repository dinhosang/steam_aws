#!/bin/bash

###

export BUILD='build'
export RUN='run'

export LINT='lint'
export FORMAT='fmt'
export FORMAT_FIX='fmt:fix'
export TEST='test'
export TEST_CI='test:ci'
export TEST_NO_COV='test:nocov'

export DOCKER_TOOLING_ACCEPTED_COMMANDS=("$BUILD" "$RUN")
export DOCKER_TOOLING_ACCEPTED_SUB_COMMANDS=("$LINT" "$FORMAT" "$FORMAT_FIX" "$TEST" "$TEST_CI" "$TEST_NO_COV")

###

export STEAM_AWS_TOOLING_IMAGE=steam_aws_tooling

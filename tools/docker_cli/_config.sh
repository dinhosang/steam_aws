#!/bin/bash

export BUILD='build'
export RUN='run'

export DOCKER_CLI_ACCEPTED_COMMANDS=("$BUILD" "$RUN")

###

export STEAM_AWS_RUNNER_IMAGE=steam_aws_runner
export STEAM_AWS_RUNNER_CONTAINER_USER=$STEAM_AWS_RUNNER_IMAGE

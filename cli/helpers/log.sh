#!/bin/bash

_helpers_log_module() {

    export HELPERS_LOG_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    ###

    _log() {

        local -r LINE_COLOUR=$1

        local -r TEXT=$2

        echo -e "${LINE_COLOUR}${TEXT}${ANSI_CLEAR}"
    }

    ###

    log_error() {

        local -r TEXT=$1

        _log "$LOG_ERROR" "\n\nERROR: $TEXT\n"
    }

    log_warn() {

        local -r TEXT=$1

        _log "$LOG_WARN" "WARN: $TEXT"
    }

    log_info() {

        local -r TEXT=$1

        _log "$LOG_INFO" "INFO: $TEXT"
    }

    log_start() {

        local -r TEXT=$1

        _log "$LOG_START" "\nSTART: $TEXT"
    }

    log_finish() {

        local -r TEXT=$1

        _log "$LOG_FINISH" "FINISH: $TEXT\n"
    }

    log_step() {

        local -r TEXT=$1

        _log "$LOG_STEP" "STEP: $TEXT"
    }
}

###

if [[ ${HELPERS_LOG_MODULE_IMPORTED:=false} == false ]]; then

    _helpers_log_module

fi

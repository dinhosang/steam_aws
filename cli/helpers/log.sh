#!/bin/bash


_helpers_log_module() {

    export HELPERS_LOG_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh


    ###


    _log() {
        
        local LINE_COLOUR=$1

        local TEXT=$2

        echo -e "${LINE_COLOUR}${TEXT}${ANSI_CLEAR}"
    }


    ###


    log_error() {

        local TEXT=$1

        _log $LOG_ERROR "\n\nERROR: $TEXT"
    }

    log_warn() {

        local TEXT=$1

        _log $LOG_WARN "\n\nWARN: $TEXT"
    }

    log_info() {

        local TEXT=$1

        _log $LOG_INFO "INFO: $TEXT"
    }

    log_start() {

        local TEXT=$1

        _log $LOG_START "\n\nSTART: $TEXT"
    }

    log_finish() {

        local TEXT=$1

        _log $LOG_FINISH "FINISH: $TEXT\n\n"
    }

    log_step() {

        local TEXT=$1

        _log $LOG_STEP "STEP: $TEXT"
    }
}


###


if [ -z $HELPERS_LOG_MODULE_IMPORTED ]; then 

    _helpers_log_module

fi

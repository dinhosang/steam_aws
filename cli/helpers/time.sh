#!/bin/bash

_helpers_time_module() {

    export HELPERS_TIME_MODULE_IMPORTED=true

    ###

    get_timestamp() {

        date +%Y%m%d%H%M%S
    }
}

###

if [[ ${HELPERS_TIME_MODULE_IMPORTED:=false} == false ]]; then

    _helpers_time_module

fi

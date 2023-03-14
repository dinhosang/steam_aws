#!/bin/bash

_tools_helpers_module() {

    export TOOLS_HELPERS_MODULE_EXPORTED=true

    _is_in_list() {

        local VALUE=$1
        local LIST="${*:2}"

        if [[ ${LIST[*]} =~ (' '|^)$VALUE(' '|$) ]]; then

            return 0

        else

            return 1

        fi
    }
}

###

if [ -z $TOOLS_HELPERS_MODULE_EXPORTED ]; then

    _tools_helpers_module

fi

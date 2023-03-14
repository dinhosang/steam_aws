#!/bin/bash

_helpers_list_module() {

    export HELPERS_LIST_MODULE_IMPORTED=true

    ###

    is_in_list() {

        local -r VALUE=$1
        local -r LIST="${*:2}"

        if [[ "$LIST" =~ (' '|^)$VALUE(' '|$) ]]; then

            return 0

        else

            return 1

        fi
    }
}

###

if [[ ${HELPERS_LIST_MODULE_IMPORTED:=false} == false ]]; then

    _helpers_list_module

fi

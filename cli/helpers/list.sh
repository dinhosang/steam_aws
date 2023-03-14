#!/bin/bash


_helpers_list_module() {

    export HELPERS_LIST_MODULE_IMPORTED=true


    ###


    is_in_list() {

        local VALUE=$1
        local LIST="${@:2}"

        if [[ ${LIST[*]} =~ (' '|^)$VALUE(' '|$) ]]; then

            return 0

        else

            return 1

        fi
    }

    get_flag_value_from_flags_list() {

        local FLAG_SOUGHT=$1

        for flag in "${USER_FLAGS[@]}"; do

            if [[ $flag =~ (^$FLAG_SOUGHT=.*$) ]]; then

                echo $flag | awk -F '=' '{print $NF}'

            fi

        done
    }
}


###


if [ -z $HELPERS_LIST_MODULE_IMPORTED ]; then 

    _helpers_list_module

fi

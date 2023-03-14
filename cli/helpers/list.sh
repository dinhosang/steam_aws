#!/bin/bash


is_in_list() {
    local value=$1
    local array="${@:2}"

    if [[ ${array[*]} =~ (' '|^)$value(' '|$) ]]; then
        return 0
    else
        return 1
    fi
}

get_flag_value_from_flags_list() {
    local flag_sought=$1

    for flag in "${USER_FLAGS[@]}"; do
        if [[ $flag =~ (^$flag_sought=.*$) ]]; then
            echo $flag | awk -F '=' '{print $NF}'
        fi
    done
}

#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   FUNCTIONS
##


_handle_profile_flag() {

    local profile_name=$AWS_PROFILE

    if is_in_list "$PROFILE_FLAG=.*" "${USER_FLAGS[@]}"; then

        local profile_name=$(get_flag_value_from_flags_list $PROFILE_FLAG)

    fi

    export AWS_PROFILE=$profile_name

    echo "INFO: setting AWS_PROFILE to '$AWS_PROFILE'"

}

_handle_flags() {

    _handle_profile_flag

}

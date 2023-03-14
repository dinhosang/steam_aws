#!/bin/bash

_helpers_flags_module() {

    export HELPERS_FLAGS_MODULE_IMPORTED=true

    ###

    source ./cli/config/index.sh

    source ./cli/helpers/log.sh
    source ./cli/helpers/print_help.sh

    ###

    get_flag_value_from_flags_list() {

        local -r FLAG_SOUGHT=$1

        for flag in "${USER_FLAGS[@]}"; do

            if [[ $flag =~ (^$FLAG_SOUGHT=.*$) ]]; then

                echo "$flag" | awk -F '=' '{print $NF}'

            fi

        done
    }

    ###

    _handle_profile_flag() {

        local profile_name=$AWS_PROFILE

        ###

        if is_in_list "$PROFILE_FLAG=.*" "${USER_FLAGS[@]}"; then

            profile_name=$(get_flag_value_from_flags_list $PROFILE_FLAG)

        fi

        ###

        export AWS_PROFILE=$profile_name

        ###

        if [ -z "$AWS_PROFILE" ]; then

            log_error "no AWS_PROFILE provided - please use cli/config/secrets.sh or pass in a profile via the -p flag"

            print_help_and_quit $HELP 1

        else

            log_info "setting AWS_PROFILE to '$AWS_PROFILE'"

        fi
    }

    _handle_region_flag() {

        local region=$AWS_REGION

        ###

        if is_in_list "$REGION_FLAG=.*" "${USER_FLAGS[@]}"; then

            region=$(get_flag_value_from_flags_list $REGION_FLAG)

        fi

        ###

        export AWS_REGION=$region

        ###

        if [ -z "$AWS_REGION" ]; then

            log_error "no AWS_REGION provided - please use cli/config/secrets.sh or pass in a region via the -r flag"

            print_help_and_quit $HELP 1

        else

            log_info "setting AWS_REGION to '$AWS_REGION'"

        fi
    }

    ###

    handle_flags() {

        _handle_profile_flag

        _handle_region_flag

    }
}

###

if [[ ${HELPERS_FLAGS_MODULE_IMPORTED:=false} == false ]]; then

    _helpers_flags_module

fi

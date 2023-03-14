#!/bin/bash


_helpers_flags_module() {

    export HELPERS_FLAGS_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh


    ###


    _handle_profile_flag() {

        local profile_name=$AWS_PROFILE


        ###


        if is_in_list "$PROFILE_FLAG=.*" "${USER_FLAGS[@]}"; then

            local profile_name=$(get_flag_value_from_flags_list $PROFILE_FLAG)

        fi


        ###


        export AWS_PROFILE=$profile_name


        ###


        if [ -z $AWS_PROFILE ]; then 

            log_error "no AWS_PROFILE provided - please use cli/config/secrets.sh or pass in a profile via the -p flag"

            print_help_and_quit $HELP 1
        
        else

            log_info "setting AWS_PROFILE to '$AWS_PROFILE'"

        fi
    }


    ###


    handle_flags() {

        _handle_profile_flag

    }
}


###


if [ -z $HELPERS_FLAGS_MODULE_IMPORTED ]; then 

    _helpers_flags_module

fi

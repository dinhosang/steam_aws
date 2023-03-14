#!/bin/bash


##
#   PURPOSE:
#       -   user account (like 'ubuntu') does not start with login password
#       -   creating a password during packer build doesn't seem to take
#       -   this creates a startup script to run when instance is launched
#       -   NOTE: it takes a little while for this script to run so you may not be able to RDP in immediately
#
##


# shellcheck source=packer/scripts/startup/helpers/index.sh
source /tmp/startup_helpers.sh # NOTE: location of file on packer build instance


###


create_startup_account() {

    local -r FILE_NAME=01_account.sh

    local -r SCRIPT_DESTINATION_PATH="${STARTUP_DIR}/${FILE_NAME}"


    ###


    create_startup_script_on_instance "$FILE_NAME" "$SCRIPT_DESTINATION_PATH"


    ###


    local -r PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH=/tmp/01_account.txt

    echo "STEP: writing contents of startup script"

    write_to_file_on_instance_from_script_text_file \
        "$PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH" \
        "$SCRIPT_DESTINATION_PATH"


    ###


    update_controller_script_to_run_startup_script_on_instance \
        "$FILE_NAME" \
        "$SCRIPT_DESTINATION_PATH" \
        "$STARTUP_COMPLETED_SCRIPT_PATH" \
        "$STARTUP_SCRIPT_CONTROL_PATH"


    ###


    make_startup_script_executable_on_instance "$FILE_NAME" "$SCRIPT_DESTINATION_PATH"
}


###


echo "START: creating startup script to set password for RDP login account"


create_startup_account


echo "FINISH: creating startup script to set password for RDP login account"

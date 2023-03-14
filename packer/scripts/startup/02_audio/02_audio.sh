#!/bin/bash

##
#   PURPOSE:
#       -   currently the instance does not present any audio
#       -   pulseaudio has issues with bluetooth that cause it to be unable to start correctly
#       -   this will remove those from the config for pulseaudio and then restart the service
#       -   NOTE: may be able to be done at packer build, but wanted to prove out the startup
#
#       NOTE: THIS DOES NOT CURRENTLY SOLVE THE ISSUE - REQUIRES FURTHER INVESTIGATION
#
##

# shellcheck source=packer/scripts/startup/helpers/index.sh
source /tmp/startup_helpers.sh # NOTE: location of file on packer build instance

###

create_startup_audio() {

    local FILE_NAME=02_audio.sh

    local SCRIPT_DESTINATION_PATH=$STARTUP_DIR/${FILE_NAME}

    ###

    create_startup_script_on_instance "$FILE_NAME" "$SCRIPT_DESTINATION_PATH"

    ###

    local -r PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH=/tmp/02_audio.txt

    echo "STEP: writing contents of startup script"

    write_to_file_on_instance_from_script_text_file \
        "$PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH" \
        "$SCRIPT_DESTINATION_PATH"

    ###

    update_controller_script_to_run_startup_script_on_instance \
        "$FILE_NAME" \
        "$SCRIPT_DESTINATION_PATH" \
        "$STARTUP_COMPLETED_SCRIPT_PATH" \
        "$STARTUP_SCRIPT_CONTROL_PATH" \
        false

    ###

    make_startup_script_executable_on_instance "$FILE_NAME" "$SCRIPT_DESTINATION_PATH"
}

###

echo "START: creating startup script to fix audio issues for pulseaudio"

create_startup_audio

echo "FINISH: creating startup script to fix audio issues for pulseaudio"

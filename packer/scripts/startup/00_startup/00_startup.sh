#!/bin/bash


##
#   PURPOSE:
#       -   not everything can be setup as part of the packer build
#       -   this sets up a controller script which handles the running of the various startup scripts
#       -   the controller script will also be updated by the other startup scripts
#           -   this is how it is made aware of startup scripts other than itself (the controller)
#       -   the resulting controller script would them be run at startup via the aws cli user-data
#       -   NOTE: keep in mind that it takes a little while at instance startup for the scripts to be run
#
##


# shellcheck source=packer/scripts/startup/helpers/index.sh
source /tmp/startup_helpers.sh # NOTE: location of file on packer build instance


###


create_startup() {

    local -r FILE_NAME=00_startup.sh


    ###

    echo "STEP: creating startup script directory"

    mkdir "$STARTUP_DIR"


    ###


    echo "STEP: creating startup controller script"

    create_startup_script_on_instance \
        "$FILE_NAME" \
        "$STARTUP_SCRIPT_CONTROL_PATH"


    ###


    echo "STEP: creating startup completion record file"

    touch "$STARTUP_COMPLETED_SCRIPT_PATH"


    ###

    
    local -r PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH=/tmp/00_startup.txt

    echo "STEP: writing starting contents of controller script"

    write_to_file_on_instance_from_script_text_file \
        "$PACKER_BUILD_SCRIPT_TEXT_SOURCE_PATH" \
        "$STARTUP_SCRIPT_CONTROL_PATH"


    ###


    make_startup_script_executable_on_instance "$FILE_NAME" "$STARTUP_SCRIPT_CONTROL_PATH"

}


###


echo "START: handling startup setup"


create_startup


echo "FINISH: handling startup setup"

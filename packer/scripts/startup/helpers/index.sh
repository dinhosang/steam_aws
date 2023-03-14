#!/bin/bash

_packer_scripts_startup_helpers_module() {

    export PACKER_SCRIPTS_STARTUP_HELPERS_MODULE_IMPORTED=true

    ###

    write_to_file_on_instance_from_script_text_file() {

        local -r SOURCE_FILE_PATH="$1"

        local -r DESTINATION_FILE_PATH="$2"

        ###

        if [ -z "${SOURCE_FILE_PATH}" ]; then

            echo "ERROR: pass in the source file path to write_to_file_on_instance_from_script_text_file()"

            exit 1

        fi

        if [ -z "${DESTINATION_FILE_PATH}" ]; then

            echo "ERROR: pass in the destination file path to write_to_file_on_instance_from_script_text_file()"

            exit 1

        fi

        ###

        while IFS= read -r line; do

            local updated_line="$line"

            if [[ "$line" =~ .*"# shellcheck".* ]]; then

                continue

            fi

            # shellcheck disable=SC2016
            for var_name in $(echo "$line" | grep -o -e '${\w*}'); do

                local var_name_cleaned
                var_name_cleaned=$(echo "$var_name" | sed -e 's|^\${||g' -e 's|}$||g' -e 's|^\$||g')

                local var_name_value
                var_name_value=${!var_name_cleaned}

                # shellcheck disable=SC2001
                updated_line="$(echo "$updated_line" | sed -e "s|\${${var_name_cleaned}}|${var_name_value}|g")"

            done

            if ! [[ "$updated_line" =~ .*'echo -e'.* ]]; then

                echo -e "$updated_line" >>"$DESTINATION_FILE_PATH"

            else

                echo "$updated_line" >>"$DESTINATION_FILE_PATH"

            fi

        done <"$SOURCE_FILE_PATH"
    }

    ###

    create_startup_script_on_instance() {

        local -r FILE_NAME="$1"

        local -r SCRIPT_FILE_PATH="$2"

        ###

        if [ -z "${FILE_NAME}" ]; then

            echo "ERROR: pass in the file name to create_startup_script_on_instance()"

            exit 1

        fi

        if [ -z "${SCRIPT_FILE_PATH}" ]; then

            echo "ERROR: pass in the script file path to create_startup_script_on_instance()"

            exit 1

        fi

        ###

        echo "STEP: creating startup script - '${FILE_NAME}'"

        touch "${SCRIPT_FILE_PATH}"
    }

    update_controller_script_to_run_startup_script_on_instance() {

        local -r FILE_NAME="$1"

        local -r SCRIPT_FILE_PATH="$2"

        local -r STARTUP_COMPLETED_SCRIPT_PATH="$3"

        local -r STARTUP_SCRIPT_CONTROL_PATH="$4"

        local -r SHOULD_ALWAYS_RUN="$5"

        ###

        if [ -z "${FILE_NAME}" ]; then

            echo "ERROR: pass in the file name to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        if [ -z "${SCRIPT_FILE_PATH}" ]; then

            echo "ERROR: pass in the script file path to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        if [ -z "${STARTUP_COMPLETED_SCRIPT_PATH}" ]; then

            echo "ERROR: pass in the completed script log file path to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        if [ -z "${STARTUP_SCRIPT_CONTROL_PATH}" ]; then

            echo "ERROR: pass in the controller script path to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        if [ -z "${SHOULD_ALWAYS_RUN}" ]; then

            echo "ERROR: pass in a boolean for whether the script should always run at startup to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        ###

        local PACKER_BUILD_SCRIPT_TEXT_PATH

        if [[ "${SHOULD_ALWAYS_RUN}" == true ]]; then

            echo "STEP: setting '${FILE_NAME}' to always run at every startup"

            PACKER_BUILD_SCRIPT_TEXT_PATH=/tmp/ucs_always_run_startup_script.txt

        elif [[ "${SHOULD_ALWAYS_RUN}" == false ]]; then

            echo "STEP: setting '${FILE_NAME}' to only run at very first startup"

            PACKER_BUILD_SCRIPT_TEXT_PATH=/tmp/ucs_run_startup_script.txt

        else

            echo "ERROR: pass in a boolean for whether script should always run at startup to update_controller_script_to_run_startup_script_on_instance()"

            exit 1

        fi

        ###

        echo "STEP: updating controller script to run '${FILE_NAME}'"

        write_to_file_on_instance_from_script_text_file \
            "$PACKER_BUILD_SCRIPT_TEXT_PATH" \
            "$STARTUP_SCRIPT_CONTROL_PATH"
    }

    make_startup_script_executable_on_instance() {

        local -r FILE_NAME="$1"

        local -r SCRIPT_FILE_PATH="$2"

        ###

        if [ -z "${FILE_NAME}" ]; then

            echo "ERROR: pass in the file name to make_startup_script_executable_on_instance()"

            exit 1

        fi

        if [ -z "${SCRIPT_FILE_PATH}" ]; then

            echo "ERROR: pass in the script file path to make_startup_script_executable_on_instance()"

            exit 1

        fi

        ###

        echo "STEP: make '${FILE_NAME}' executable"

        chmod +x "$SCRIPT_FILE_PATH"
    }
}

###

if [ -z "$PACKER_SCRIPTS_STARTUP_HELPERS_MODULE_IMPORTED" ]; then

    _packer_scripts_startup_helpers_module

fi

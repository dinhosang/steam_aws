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


create_startup_audio() {

    local file_name=02_audio.sh

    local script_file_path=$STARTUP_DIR/${file_name}
 
    
    ###


    echo "STEP: creating startup script - '${file_name}'"

    touch $script_file_path


    ###


    echo "STEP: writing contents of startup script"

    echo -e '#!/bin/bash\n\n' >> $script_file_path
    
    echo -e "sudo sed -Ei '/load-module module-bluetooth*/s/^/#/' /etc/pulse/default.pa\n" >> $script_file_path

    echo -e "su - ubuntu -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus XDG_RUNTIME_DIR=/run/user/1000 systemctl --user restart pulseaudio'\n" >> $script_file_path

    
    ###


    echo "STEP: updating controller script to run '${file_name}'"

    echo "echo -e 'START: ${file_name}\n' >> ${STARTUP_COMPLETED_SCRIPT_PATH}" >> $STARTUP_SCRIPT_CONTROL_PATH

    echo -e "${script_file_path} >> ${STARTUP_COMPLETED_SCRIPT_PATH} 2>&1\n" >> $STARTUP_SCRIPT_CONTROL_PATH

    echo "echo -e '\nFINISH: ${file_name}\n\n' >> ${STARTUP_COMPLETED_SCRIPT_PATH}" >> $STARTUP_SCRIPT_CONTROL_PATH

    echo -e '\n\n' >> $STARTUP_SCRIPT_CONTROL_PATH


    ###
    

    echo "STEP: make '${file_name}' executable"

    chmod +x $script_file_path

}


###


echo "START: creating startup script to fix audio issues for pulseaudio"


create_startup_audio


echo "FINISH: creating startup script to fix audio issues for pulseaudio"


# douglas TODO: remove below once not needed
# systemctl --user status pulseaudio
# systemctl --user enable pulseaudio
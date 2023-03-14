#!/bin/bash


##
#   PURPOSE:
#       -   user account (like 'ubuntu') does not start with login password
#       -   creating a password during packer build doesn't seem to take
#       -   this creates a startup script to run when instance is launched
#       -   NOTE: it takes a little while for this script to run so you may not be able to RDP in immediately
#
##


create_startup_account() {

    local file_name=01_account.sh

    local script_file_path=$STARTUP_DIR/${file_name}
 
    
    ###


    echo "STEP: creating startup script - '${file_name}'"

    touch $script_file_path


    ###


    echo "STEP: writing contents of startup script"

    echo -e '#!/bin/bash\n\n' >> $script_file_path

    echo -e "INSTANCE_LOGIN_USER_NAME=${INSTANCE_LOGIN_USER_NAME}\n" >> $script_file_path

    echo -e "INSTANCE_LOGIN_USER_PASSWORD=${INSTANCE_LOGIN_USER_PASSWORD}\n" >> $script_file_path

    echo 'echo -en "${INSTANCE_LOGIN_USER_PASSWORD}\n${INSTANCE_LOGIN_USER_PASSWORD}\n" | sudo passwd ${INSTANCE_LOGIN_USER_NAME}' >> $script_file_path

    echo -e '\n' >> $script_file_path

    
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


echo "START: creating startup script to set password for RDP login account"


create_startup_account


echo "FINISH: creating startup script to set password for RDP login account"

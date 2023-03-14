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


echo "START: handling startup setup"


###


echo "STEP: creating startup script directory"

mkdir $STARTUP_DIR


###


echo "STEP: creating startup controller script"

touch $STARTUP_SCRIPT_CONTROL_PATH


###


echo "STEP: creating startup completion record file"

touch $STARTUP_COMPLETED_SCRIPT_PATH


###


echo "STEP: writing starting contents of controller script"

echo -e '#!/bin/bash\n\n' >> $STARTUP_SCRIPT_CONTROL_PATH

echo "echo -e 'START: running startup scripts\n\n' >> ${STARTUP_COMPLETED_SCRIPT_PATH}" >> $STARTUP_SCRIPT_CONTROL_PATH

echo -e '\n\n' >> $STARTUP_SCRIPT_CONTROL_PATH


###


echo "STEP: making controller script executable"

chmod +x $STARTUP_SCRIPT_CONTROL_PATH


###


echo "FINISH: handling startup setup"

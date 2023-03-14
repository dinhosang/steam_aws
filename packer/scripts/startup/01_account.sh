#!/bin/bash


##
#   START
##


echo "START: create startup script to set password for RDP login account"


##
#  Create file
##


_file_name=/01_account.sh

touch $_file_name


##
#   ENTER CONTENTS FOR STARTUP FILE
##


echo '#!/bin/bash' >> $_file_name

echo "INSTANCE_LOGIN_USER_NAME=$INSTANCE_LOGIN_USER_NAME" >> $_file_name

echo "INSTANCE_LOGIN_USER_PASSWORD=$INSTANCE_LOGIN_USER_PASSWORD" >> $_file_name

echo 'echo -en "${INSTANCE_LOGIN_USER_PASSWORD}\n${INSTANCE_LOGIN_USER_PASSWORD}\n" | sudo passwd ${INSTANCE_LOGIN_USER_NAME}' >> $_file_name

chmod +x $_file_name


##
#   FINISH
##


echo "FINISH: create startup script to set password for RDP login account"

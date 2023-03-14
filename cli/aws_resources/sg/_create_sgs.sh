#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/helpers/index.sh


##
#   FUNCTIONS
##


_create_aws_connect_sg(){

    echo "START: Create AWS Connect SG"


    ##
    #   CONFIG
    ##


    local SG_NAME_PREFIX=$SG_NAME_PREFIX_AWS_CONNECT
    local SG_DESC='Allow ssh access (Security Group)'
    local IP_PROTOCOL='tcp'
    local FROM_PORT=22
    local TO_PORT=22
    local IP_V4_RANGES='[{CidrIp=3.8.37.24/29,Description="Allow amazon connect browser ssh - IPV4"}]'
    local IP_V6_RANGES='[]'


    ##
    #   RUN
    ##


    _create_sg \
        $SG_NAME_PREFIX \
        "$SG_DESC" \
        $IP_PROTOCOL \
        $FROM_PORT \
        $TO_PORT \
        "$IP_V4_RANGES" \
        "$IP_V6_RANGES"

    echo "FINISH: Create AWS Connect SG"
}

_create_rdp_sg(){

    echo "START: Create RDP SG"


    ##
    #   CONFIG
    ##


    local SG_NAME_PREFIX=$SG_NAME_PREFIX_RDP
    local SG_DESC='Allow remote desktop access (Security Group)'
    local IP_PROTOCOL='tcp'
    local FROM_PORT=3389
    local TO_PORT=3389


    ##
    #   IP ADDRESSES - GRAB FROM CONFIG (IF PRESENT)
    ##


    local ip_v4_address=$IP_V4
    local ip_v6_address=$IP_V6


    ##
    #   IP ADDRESSES - GRAB FROM EXTERNAL URL (IF NOT IN CONFIG)
    ##


    if [ -z "$ip_v4_address" ]; then

        ip_v4_address="$(_get_ip_4)"

    fi

    if [ -z "$ip_v6_address" ]; then

        ip_v6_address="$(_get_ip_6)"

    fi


    ##
    #   IP ADDRESSES - PREP FOR AWS CLI
    ##


    local IP_V4_RANGES="[{CidrIp=$ip_v4_address/32,Description=\"Allow access from personal device - IPV4\"}]"
    local IP_V6_RANGES="[{CidrIpv6=$ip_v6_address/128,Description=\"Allow access from personal device - IPV6\"}]"


    ##
    #   RUN
    ##


    _create_sg \
        $SG_NAME_PREFIX \
        "$SG_DESC" \
        $IP_PROTOCOL \
        $FROM_PORT \
        $TO_PORT \
        "$IP_V4_RANGES" \
        "$IP_V6_RANGES"

    echo "FINISH: Create RDP SG"

}

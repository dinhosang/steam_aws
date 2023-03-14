#!/bin/bash

_aws_resources_sg_create_sgs_module() {

    export AWS_RESOURCES_SG_CREATE_SGS_MODULE_IMPORTED=true

    ###

    source ./cli/helpers/index.sh
    source ./cli/aws_resources/sg/helpers.sh

    ###

    create_aws_connect_sg() {

        log_start "create aws connect sg"

        ###

        local SG_NAME_PREFIX=$SG_NAME_PREFIX_AWS_CONNECT
        local SG_DESC='Allow ssh access (Security Group)'
        local IP_PROTOCOL='tcp'
        local FROM_PORT=22
        local TO_PORT=22
        local IP_V4_RANGES='[{CidrIp=3.8.37.24/29,Description="Allow amazon connect browser ssh - IPV4"}]'
        local IP_V6_RANGES='[]'

        ###

        create_sg \
            $SG_NAME_PREFIX \
            "$SG_DESC" \
            $IP_PROTOCOL \
            $FROM_PORT \
            $TO_PORT \
            "$IP_V4_RANGES" \
            "$IP_V6_RANGES"

        ###

        log_finish "create aws connect sg"
    }

    create_rdp_sg() {

        log_start "create rdp sg"

        ###

        local SG_NAME_PREFIX=$SG_NAME_PREFIX_RDP
        local SG_DESC='Allow remote desktop access (Security Group)'
        local IP_PROTOCOL='tcp'
        local FROM_PORT=3389
        local TO_PORT=3389

        ###

        local ip_v4_address=$IP_V4
        local ip_v6_address=$IP_V6

        ###

        if [ -z "$ip_v4_address" ]; then

            ip_v4_address="$(get_ip_4)"

        fi

        if [ -z "$ip_v6_address" ]; then

            ip_v6_address="$(get_ip_6)"

        fi

        ###

        local IP_V4_RANGES="[{CidrIp=$ip_v4_address/32,Description=\"Allow access from personal device - IPV4\"}]"
        local IP_V6_RANGES="[{CidrIpv6=$ip_v6_address/128,Description=\"Allow access from personal device - IPV6\"}]"

        ###

        create_sg \
            $SG_NAME_PREFIX \
            "$SG_DESC" \
            $IP_PROTOCOL \
            $FROM_PORT \
            $TO_PORT \
            "$IP_V4_RANGES" \
            "$IP_V6_RANGES"

        ###

        log_finish "create rdp sg"
    }
}

###

if [ -z $AWS_RESOURCES_SG_CREATE_SGS_MODULE_IMPORTED ]; then

    _aws_resources_sg_create_sgs_module

fi

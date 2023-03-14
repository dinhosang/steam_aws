#!/bin/bash

_aws_resources_sg_delete_sgs_module() {

    export AWS_RESOURCES_SG_DELETE_SGS_MODULE_IMPORTED=true

    ###

    source ./cli/helpers/index.sh

    ###

    delete_aws_connect_sg() {

        log_start "delete aws connect sg"

        ####

        delete_sg $SG_NAME_PREFIX_AWS_CONNECT

        ###

        log_finish "delete aws connect sg"
    }

    delete_rdp_sg() {

        log_start "delete rdp sg"

        ###

        delete_sg $SG_NAME_PREFIX_RDP

        ###

        log_finish "delete rdp sg"
    }

}

###

if [ -z $AWS_RESOURCES_SG_DELETE_SGS_MODULE_IMPORTED ]; then

    _aws_resources_sg_delete_sgs_module

fi

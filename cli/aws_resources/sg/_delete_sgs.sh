#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/helpers/index.sh


##
#   FUNCTIONS
##


_delete_aws_connect_sg(){

    echo "START: Delete AWS Connect SG"


    ##
    #   RUN
    ##


    _delete_sg $SG_NAME_PREFIX_AWS_CONNECT

    echo "FINISH: Delete AWS Connect SG"

}

_delete_rdp_sg(){

    echo "START: Delete RDP SG"


    ##
    #   RUN
    ##


    _delete_sg $SG_NAME_PREFIX_RDP

    echo "FINISH: Delete RDP SG"
}

#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh

source ./cli/aws_resources/ip/_base_helper.sh


##
#   FUNCTIONS
##


_get_ip_4() {

    ##
    #   GET IP
    ##


    local ip=$(_get_ip $IP_4_QUERY_URL)


    ##
    #   RETURN
    ##

    echo $ip
}

_get_ip_6() {

    ##
    #   GET IP
    ##


    local ip=$(_get_ip $IP_6_QUERY_URL)


    ##
    #   RETURN
    ##

    echo $ip
}

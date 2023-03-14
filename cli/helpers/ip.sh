#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/config/index.sh


##
#   FUNCTIONS
##


_get_ip(){

    ##
    #   REQUIRED INPUT
    ##


    if [ -z ${1+x} ]; then 
        
        printf 'IP_URL not found - Must be passed in as first argument to function.\n\n'

        exit 1

    fi


    ##
    #   CONFIG
    ##

    
    local IP_URL=$1


    ##
    #   IP - GET
    ##


    local ip_raw="$(curl $IP_URL)"


    ##
    #   IP - CLEANUP
    ##


    local ip=$(echo $ip_raw | awk -F ',' '{print $2}')


    ##
    #   IP - CONFIRM
    ##


    if [ -z "$ip" ]; then

        echo "ERROR: could not retrieve ip address from '$IP_URL', please use secrets config"

        exit 1

    fi
    

    ##
    #   RETURN
    ##


    echo $ip
}

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

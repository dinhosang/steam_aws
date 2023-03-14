#!/bin/bash


_helpers_ip_module() {
    
    export HELPERS_IP_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh

    source ./cli/helpers/index.sh


    ###


    _get_ip(){

        if [ -z ${1+x} ]; then 
            
            log_error 'IP_URL not found - Must be passed in as first argument to function.'

            exit 1

        fi
        
        local IP_URL=$1


        ###


        local ip_raw="$(curl $IP_URL)"

        local ip=$(echo $ip_raw | awk -F ',' '{print $2}')


        ###


        if [ -z "$ip" ]; then

            log_error "could not retrieve ip address from '$IP_URL', please use secrets config"

            exit 1

        fi
        

        ###


        echo $ip
    }


    ###


    get_ip_4() {

        local ip=$(_get_ip $IP_4_QUERY_URL)

        echo $ip
    }

    get_ip_6() {

        local ip=$(_get_ip $IP_6_QUERY_URL)

        echo $ip
    }
}


###


if [ -z $HELPERS_IP_MODULE_IMPORTED ]; then 

    _helpers_ip_module

fi

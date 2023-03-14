#!/bin/bash


_helpers_time_module() {

    export HELPERS_TIME_MODULE_IMPORTED=true


    ###


    get_timestamp(){
    
        echo "$(date +%Y%m%d%H%M%S)"
    }
}


###


if [ -z $HELPERS_TIME_MODULE_IMPORTED ]; then 

    _helpers_time_module

fi

#!/bin/bash

_config_index_module() {

    export CONFIG_INDEX_MODULE_IMPORTED=true

    ###

    source ./cli/config/_cli_constants.sh
    source ./cli/config/general_config.sh
    source ./cli/config/user_specific_config.sh
}

###

if [ -z $CONFIG_INDEX_MODULE_IMPORTED ]; then

    _config_index_module

fi

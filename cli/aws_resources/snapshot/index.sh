#!/bin/bash


_aws_resources_snapshot_module() {

    export AWS_RESOURCES_SNAPSHOT_MODULE_IMPORTED=true


    ###


    source ./cli/config/index.sh
    
    source ./cli/helpers/index.sh


    ###


    delete_snapshot() {
        
        log_start "delete snapshot"


        ###


        if [ -z ${1+x} ]; then 
            
            log_error "at least one snapshot id must be passed to 'delete_snapshot()'"

            exit 1

        fi


        ###


        local SNAPSHOT_IDS=(${@})


        ###


        for snapshot_id in ${SNAPSHOT_IDS[*]}; do

            log_step "deleting volume snapshot - '$snapshot_id'"

            
            ###


            local _result=$(aws --profile $AWS_PROFILE ec2 delete-snapshot \
                --region $AWS_REGION \
                --snapshot-id $snapshot_id
            )


            ###


            local snapshot_deleted=false

            {
                # try

                does_snapshot_exist_throw_if_not $snapshot_id

            } || {
                
                # catch

                snapshot_deleted=true

            }

            if [ $snapshot_deleted == true ]; then

                log_step "volume snapshot '$snapshot_id' deleted"

            else

                log_warn "volume snapshot '$snapshot_id' may NOT have been deleted"

            fi

        done


        ###


        log_finish "delete snapshot"
    }
}


###


if [ -z $AWS_RESOURCES_SNAPSHOT_MODULE_IMPORTED ]; then 

    _aws_resources_snapshot_module

fi

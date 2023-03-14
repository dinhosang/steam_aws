#!/bin/bash


##
#   IMPORTS / EXPORTS
##


source ./cli/aws_resources/ami/index.sh
source ./cli/aws_resources/ec2/index.sh
source ./cli/aws_resources/instance_profile/index.sh
source ./cli/aws_resources/sg/index.sh


##
#   FUNCTIONS
##


_create_instance_and_related_resources(){

    echo "START: Create Instance and Related Resources"

    ##
    #   CREATE INSTANCE PROFILE
    ##


    _create_instance_profile


    ##
    #   CREATE SGs
    ##


    _create_aws_connect_sg
    _create_rdp_sg


    ##
    #   CREATE EC2
    ##


    _create_ec2

    echo "FINISH: Create Instance and Related Resources"
}

_delete_all_but_most_recent_instance() {

    echo "START: prune instances"

    
    ##
    #   INSTANCES - RETRIEVE IDs
    ##


    local ec2_instance_ids=($(_get_running_instance_ids false))


    if [ -z "$ec2_instance_ids" ]; then

        echo "INFO: No additional instances found running"

    else

        ##
        #   INSTANCES - DELETE
        ##


       _delete_ec2 ${ec2_instance_ids[*]}

    fi

    echo "FINISH: prune instances"
}

_delete_instance_and_related_resources(){

    echo "START: Delete Instance and Related Resources"

    ##
    #   DELETE EC2 INSTANCE
    ##


    local instance_id=($(_get_running_instance_ids true))

    if [ -z "$instance_id" ]; then

        echo "INFO: No instances found running"

    else

       _delete_ec2 ${instance_id[*]}

    fi


    # #
    #   DELETE SGs
    # #


    _delete_aws_connect_sg
    _delete_rdp_sg


    ##
    #   DELETE INSTANCE PROFILE
    ##


    _delete_instance_profile

    echo "FINISH: Delete Instance and Related Resources"
}

#!/bin/bash

_helpers_print_help_module() {

    export HELPERS_PRINT_HELP_MODULE_IMPORTED=true

    ###

    _print_text() {

        echo "$1"
    }

    ###

    _print_help() {

        local text="
        -----

        A tool to spin up an aws instance with linux, steam, rdp, and a gui.

        -----

            ./cli.sh help
                    
                displays this text

            ./cli.sh ami <sub_command> [flags]
                
                to create / update / delete / prune AMIs
                
                use './cli.sh ami help' for details

            ./cli.sh instance <sub_command> [flags]
                
                to create / delete / prune ec2 instances
                
                use './cli.sh instance help' for details
            
            ./cli.sh snapshot <sub_command> [flags]
                
                to prune / delete volume snapshots
                
                use './cli.sh snapshot help' for details

        -----
        "

        _print_text "$text"
    }

    _print_help_ami() {

        local text="
        -----

        To create, update, delete, or prune AMIs
        
        -----

            ./cli.sh ami help
                    
                displays this text

            ./cli.sh ami create [flags]
                
                to create a fresh ami via packer

                NOTE:

                    this will create a new snapshot, keep in mind if you deleted everything but
                    your latest snapshot previously.
                    
                    You may need to tweak the cli to use your existing snapshot in the device mapping
                    of the .pkr.hcl file so that it doesn't lose your previous data.

                    Not an issue if you never intend to delete the amis, or intend to delete everything
                    after testing the cli out.

            ./cli.sh ami update [flags]
                
                to create a new ami based off of the most recently created running instance

            ./cli.sh ami delete [flags]
                
                to delete the most recently created ami

            ./cli.sh ami prune [flags]
                
                to delete all but the most recently created ami, useful after using 'ami update'

        -----

            flags include:


            -p=<profile_name> 

                the name of the profile to use when connecting to aws.
                
                Requires ~/.aws/config to already be set up with that profile.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_PROFILE key

                
                    example: './cli.sh ami create -p=zelda'

        -----
        "

        _print_text "$text"
    }

    _print_help_instance() {

        local text="
        -----

        To create, delete, or prune ec2 instances
        
        -----

            ./cli.sh instance help
                    
                displays this text

            ./cli.sh instance create [flags]
                
                to create instance

            ./cli.sh instance delete [flags]
                
                to delete most recently launched instance
            
            ./cli.sh instance prune [flags]
                
                to delete all but the most recently launched instance

                NOTE:
                    
                    cli mostly expects there to only be one instance running
                    and thus being actively used at a time. 

                    This 'prune' option is mostly here in case create is run
                    multiple times without first running delete on instances.

        -----

            flags include:


            -p=<profile_name> 

                the name of the profile to use when connecting to aws.
                
                Requires ~/.aws/config to already be set up with that profile.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_PROFILE key

                
                    example: './cli.sh instance create -p=zelda'

        -----
        "

        _print_text "$text"
    }

    _print_help_volume_snapshot() {

        local text="
        -----

        To delete or prune volume snapshots
        
        -----

            ./cli.sh snapshot help
                    
                displays this text

            ./cli.sh snapshot delete [flags]
                
                to delete most recently created volume snapshot

                NOTE:

                    requires the relevant ami to be deleted first
            
            ./cli.sh snapshot prune [flags]
                
                to delete all but the most recently created volume snapshot

                NOTE:

                    requires any related amis to be pruned first

        -----

            flags include:


            -p=<profile_name> 

                the name of the profile to use when connecting to aws.
                
                Requires ~/.aws/config to already be set up with that profile.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_PROFILE key

                
                    example: './cli.sh snapshot prune -p=zelda'

        -----
        "

        _print_text "$text"
    }

    print_help_and_quit() {

        if [ "$1" == "$INSTANCE" ]; then

            _print_help_instance

        elif [ "$1" == "$AMI" ]; then

            _print_help_ami

        elif [ "$1" == "$SNAPSHOT" ]; then

            _print_help_volume_snapshot

        else

            _print_help

        fi

        exit "$2"
    }
}

###

if [ -z $HELPERS_PRINT_HELP_MODULE_IMPORTED ]; then

    _helpers_print_help_module

fi

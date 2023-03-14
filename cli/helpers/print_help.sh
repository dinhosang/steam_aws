#!/bin/bash

_helpers_print_help_module() {

    export HELPERS_PRINT_HELP_MODULE_IMPORTED=true

    ###

    _print_text() {

        echo -e "$1"
    }

    ###

    _print_help() {

        local text="
        -----

        A tool to spin up an aws instance with linux, steam, rdp, and a gui.

        -----

            ${ANSI_GREEN}./docker_cli.sh run help${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh help${ANSI_CLEAR}
                    
                displays this text

            ${ANSI_GREEN}./docker_cli.sh run ami${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to create / update / delete / prune AMIs
                
                use ${ANSI_GREY}'./docker_cli.sh run ami help${ANSI_CLEAR}' OR ${ANSI_GREY}'./cli.sh ami help${ANSI_CLEAR}' for details

            ${ANSI_GREEN}./docker_cli.sh run instance${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh instance${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to create / delete / prune ec2 instances
                
                use ${ANSI_GREY}'./docker_cli.sh run instance help${ANSI_CLEAR}' OR ${ANSI_GREY}'./cli.sh instance help${ANSI_CLEAR}' for details
            
            ${ANSI_GREEN}./docker_cli.sh run snapshot${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh snapshot${ANSI_CLEAR} ${ANSI_YELLOW}<sub_command>${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to prune / delete volume snapshots
                
                use ${ANSI_GREY}'./docker_cli.sh run snapshot help${ANSI_CLEAR}' OR ${ANSI_GREY}'./cli.sh snapshot help${ANSI_CLEAR}' for details

        -----
        "

        _print_text "$text"
    }

    _print_help_ami() {

        local text="
        -----

        To create, update, delete, or prune AMIs
        
        -----

            ${ANSI_GREEN}./docker_cli.sh run ami help${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami help${ANSI_CLEAR}
                    
                displays this text

            ${ANSI_GREEN}./docker_cli.sh run ami create${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami create${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to create a fresh ami via packer

                NOTE:

                    this will create a new snapshot, keep in mind if you deleted everything but
                    your latest snapshot previously.
                    
                    You may need to tweak the cli to use your existing snapshot in the device mapping
                    of the .pkr.hcl file so that it doesn't lose your previous data.

                    Not an issue if you never intend to delete the amis, or intend to delete everything
                    after testing the cli out.

            ${ANSI_GREEN}./docker_cli.sh run ami update${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami update${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to create a new ami based off of the most recently created running instance

            ${ANSI_GREEN}./docker_cli.sh run ami delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to delete the most recently created ami

            ${ANSI_GREEN}./docker_cli.sh run ami prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh ami prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to delete all but the most recently created ami, useful after using 'ami update'

        -----

            flags include:


            -p=<profile_name> 

                the name of the profile to use when connecting to aws.
                
                Requires ~/.aws/config to already be set up with that profile.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_PROFILE key

                
                    examples: 

                        '${ANSI_GREEN}./docker_cli.sh run ami create -p=zelda${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh ami create -p=zelda${ANSI_CLEAR}'

            -r=<aws_region>

                the name of the region to use when connecting to aws.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_REGION key


                    example:

                        '${ANSI_GREEN}./docker_cli.sh run ami create -r=us-east-1${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh ami create -r=us-east-1${ANSI_CLEAR}'

        -----
        "

        _print_text "$text"
    }

    _print_help_instance() {

        local text="
        -----

        To create, delete, or prune ec2 instances
        
        -----

            ${ANSI_GREEN}./docker_cli.sh instance help${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh instance help${ANSI_CLEAR}
                    
                displays this text

            ${ANSI_GREEN}./docker_cli.sh instance create${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh instance create${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to create instance

            ${ANSI_GREEN}./docker_cli.sh run instance delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh instance delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to delete most recently launched instance
            
            ${ANSI_GREEN}./docker_cli.sh run instance prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh instance prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}

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

                
                    example:

                        '${ANSI_GREEN}./docker_cli.sh run instance create -p=zelda${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh instance create -p=zelda${ANSI_CLEAR}'

            -r=<aws_region>

                the name of the region to use when connecting to aws.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_REGION key


                    example:

                        '${ANSI_GREEN}./docker_cli.sh run instance create -r=us-east-1${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh instance create -r=us-east-1${ANSI_CLEAR}'

        -----
        "

        _print_text "$text"
    }

    _print_help_volume_snapshot() {

        local text="
        -----

        To delete or prune volume snapshots
        
        -----

            ${ANSI_GREEN}./docker_cli.sh run snapshot help${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh snapshot help${ANSI_CLEAR}
                    
                displays this text

            ${ANSI_GREEN}./docker_cli.sh run snapshot delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh snapshot delete${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
                to delete most recently created volume snapshot

                NOTE:

                    requires the relevant ami to be deleted first
            
            ${ANSI_GREEN}./docker_cli.sh run snapshot prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR} OR ${ANSI_CYAN}./cli.sh snapshot prune${ANSI_CLEAR} ${ANSI_GREY}[flags]${ANSI_CLEAR}
                
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

                
                    example:

                        '${ANSI_GREEN}./docker_cli.sh run snapshot prune -p=zelda${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh snapshot prune -p=zelda${ANSI_CLEAR}'


            -r=<aws_region>

                the name of the region to use when connecting to aws.

                If not passed in it will default to value set in ./cli/config/secrets.sh
                for _AWS_REGION key


                    example:

                        '${ANSI_GREEN}./docker_cli.sh run instance create -r=us-east-1${ANSI_CLEAR}'

                        '${ANSI_CYAN}./cli.sh instance create -r=us-east-1${ANSI_CLEAR}'


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

if [[ ${HELPERS_PRINT_HELP_MODULE_IMPORTED:=false} == false ]]; then

    _helpers_print_help_module

fi

build {

    sources = [ "source.amazon-ebs.steam_play_instance" ]


    //


    provisioner "shell" {
        script = "./packer/scripts/01_prepare_os.sh"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive"
        ]
    }

    provisioner "shell" {
        script = "./packer/scripts/02_steam.sh"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive"
        ]
    }

    provisioner "shell" {
        script = "./packer/scripts/03_gui.sh"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive"
        ]
    }

    provisioner "shell" {
        script = "./packer/scripts/04_rdp.sh"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive"
        ]
    }

    // // NOTE: can use if you would like to backup save data separately to the volume
    // provisioner "shell" {
    //     script = "./packer/scripts/05_awscli.sh"
    //     environment_vars = [
    //         "DEBIAN_FRONTEND=noninteractive"
    //     ]
    // }


    // STARTUP PROVISIONSERS


    provisioner "file" {
        source = "./packer/scripts/startup/helpers/index.sh"
        destination = "/tmp/startup_helpers.sh"
    }

    provisioner "file" {
        source = "./packer/scripts/startup/helpers/ucs_run_startup_script.txt"
        destination = "/tmp/ucs_run_startup_script.txt"
    }

    provisioner "file" {
        source = "./packer/scripts/startup/helpers/ucs_always_run_startup_script.txt"
        destination = "/tmp/ucs_always_run_startup_script.txt"
    }


    //


    provisioner "file" {
        source = "./packer/scripts/startup/00_startup/00_startup.txt"
        destination = "/tmp/00_startup.txt"
    }

    provisioner "shell" {
        script = "./packer/scripts/startup/00_startup/00_startup.sh"
        // NOTE: below is to allow the script to be run as root during a packer build
        execute_command = "chmod +x {{ .Path }}; echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive",
            "STARTUP_DIR=${var.startup_dir}",
            "STARTUP_SCRIPT_CONTROL_PATH=${var.startup_control_script_path}",
            "STARTUP_COMPLETED_SCRIPT_PATH=${var.startup_completed_script_path}",
        ]
    }



    //


    provisioner "file" {
        source = "./packer/scripts/startup/01_account/01_account.txt"
        destination = "/tmp/01_account.txt"
    }

    provisioner "shell" {
        script = "./packer/scripts/startup/01_account/01_account.sh"
        execute_command = "chmod +x {{ .Path }}; echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive",
            "STARTUP_DIR=${var.startup_dir}",
            "STARTUP_SCRIPT_CONTROL_PATH=${var.startup_control_script_path}",
            "STARTUP_COMPLETED_SCRIPT_PATH=${var.startup_completed_script_path}",
            "INSTANCE_LOGIN_USER_NAME=${var.instance_login_user_name}",
            "INSTANCE_LOGIN_USER_PASSWORD=${var.instance_login_user_password}",
        ]
    }


    //


    // NOTE: This does not currently solve the audio issue, leaving here to show another example of a startup script
    provisioner "file" {
        source = "./packer/scripts/startup/02_audio/02_audio.txt"
        destination = "/tmp/02_audio.txt"
    }

    // NOTE: This does not currently solve the audio issue, leaving here to show another example of a startup script
    provisioner "shell" {
        script = "./packer/scripts/startup/02_audio/02_audio.sh"
        execute_command = "chmod +x {{ .Path }}; echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive",
            "STARTUP_DIR=${var.startup_dir}",
            "STARTUP_SCRIPT_CONTROL_PATH=${var.startup_control_script_path}",
            "STARTUP_COMPLETED_SCRIPT_PATH=${var.startup_completed_script_path}",
        ]
    }
}

local "timestamp" {
    expression  = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_name" {
    type        = string
    description = "AMI name prefix"
}

variable "purpose" {
    type    = string
    description = "value of the 'Purpose' tag of the AMI"
}

variable "region" {
    type    = string
    description = "AWS Region to target"
}

variable "profile" {
    type    = string
    description = "AWS login profile to use to run build"
}

variable "root_volume_name" {
    type    = string
    description = "Name for the root aws ebs volume - see aws docs for details"
}

variable "os_version" {
    type    = string
    description = "OS Version for tagging purposes - should match os used by source ami"
}

variable "instance_type" {
    type    = string
    description = "AWS EC2 instance type to use"
}

variable "os_source_ami_name" {
    type    = string
    description = "Base AMI to use for the OS and starting setup"
}

variable "instance_login_user_name" {
    type    = string
    description = "Username to use when logging into instance - usually 'ubuntu' for ubuntu or 'ec2-user' for Amazon Linux"
}

variable "instance_login_user_password" {
    type    = string
    sensitive = true
    description = "Password to use when loggin into the 'instance_login_user_name' account on instance"
}

source "amazon-ebs" "steam_play_instance" {
    ami_name        = "${var.ami_name}_${local.timestamp}"
    instance_type   = "${var.instance_type}"
    region          = "${var.region}"
    profile         = "${var.profile}"
    source_ami_filter {
        filters = {
            name                = "${var.os_source_ami_name}"
            root-device-type    = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = [ "amazon" ]
    }
    ssh_username    = "${var.instance_login_user_name}"
    run_tags = {
        Runner      = "Packer"
    }
    tags = {
        OS_Version  = "${var.os_version}"
        Purpose     = "${var.purpose}"
    }
}


build {

    sources = [ "source.amazon-ebs.steam_play_instance" ]

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

    provisioner "shell" {
        script = "./packer/scripts/startup/01_account.sh"
        // NOTE: below is to allow the script to be run as root during a packer build
        execute_command = "chmod +x {{ .Path }}; echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive",
            "INSTANCE_LOGIN_USER_NAME=${var.instance_login_user_name}",
            "INSTANCE_LOGIN_USER_PASSWORD=${var.instance_login_user_password}",
        ]
    }

    // NOTE: can use if you would like to backup save data separately to the volume
    // provisioner "shell" {
    //     script = "./packer/scripts/05_awscli.sh"
    //     environment_vars = [
    //         "DEBIAN_FRONTEND=noninteractive"
    //     ]
    // }
}

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

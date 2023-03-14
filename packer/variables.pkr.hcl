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

variable "startup_dir" {
    type    = string
    description = "location of the startup script directory"
}

variable "startup_control_script_path" {
    type    = string
    description = "location of the startup controller script"
}

variable "startup_completed_script_path" {
    type    = string
    description = "location of the startup completed script"
}

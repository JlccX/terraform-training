variable "region" {
    description = "AWS region. Changing it will lead to loss of complete stack."
    default = "us-east-1"
}

variable "environment" {
    default = "prod"
}

variable "allow_ssh_access" {
    description = "List of CIDR blocks that can access instances vis SSH"
    default = ["0.0.0.0/0"]
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}


variable "external_nameserver" {
    default = "8.8.8.8"
}


variable "extra_packages" {
    description = "Additional packages to install for a particular module"

    default = {
        base            = "wget"
        MightyTrousers  = "wget bind-utils"
    }
}


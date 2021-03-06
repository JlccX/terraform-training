provider "aws" {
    region = "us-east-1"
    #access_key = {}
    #secret_key = {}
}

/*
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        #values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-16.04-amd64-server-*"]
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical 
}
*/

resource "aws_instance" "web_server" {
    ami             = "ami-33e4bc49"
    instance_type   = "t2.micro"
    key_name        = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    # Don't add spaces after EOF
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, world" > /home/ubuntu/index.html
                cd /home/ubuntu
                python -m SimpleHTTPServer "${var.server_port}"
                EOF

    connection {
        user        = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

    tags {
        name = "myTag"
        Name = "Web-Server"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-web-server-security-group"

    ingress {
        from_port   = "${var.server_port}"
        to_port     = "${var.server_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ip" {
    value = "${aws_instance.web_server.public_ip}"
}

output "public_port" {
    value = "${var.server_port}"
}

#This line add an elastic IP-Address to one instance
#This IP-Address is public, and should be associated to one instance.
# resource "aws_eip" "ip" {
#     instance = "${aws_instance.terraform_example.id}"
# }
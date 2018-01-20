provider "aws" {
    region = "us-east-1"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
    vpc_id      = "${aws_vpc.my_vpc.id}"
    cidr_block  = "10.0.1.0/24"
}

#ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20180110 (ami-33e4bc49)
resource "aws_instance" "web_server" {
    ami             = "ami-33e4bc49"
    instance_type   = "t2.micro"
    subnet_id       = "${aws_subnet.public.id}"
    key_name        = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
    associate_public_ip_address = true

    # Don't add spaces after EOF
    user_data = <<-EOF
                #!/bin/bash
                cd /home/ubuntu
                echo "Hello, world" > index.html
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
    name            = "terraform-web-server-security-group"
    description     = "Allow HTTP traffic"
    vpc_id          = "${aws_vpc.my_vpc.id}"

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

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ip" {
    value = "${aws_instance.web_server.public_ip}"
}

output "public_port" {
    value = "${var.server_port}"
}
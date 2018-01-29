provider "aws" {
    region = "us-east-1"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

#ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20180110 (ami-33e4bc49)
resource "aws_instance" "web_server" {
    ami             = "ami-33e4bc49"
    instance_type   = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    # Don't add spaces after EOF
    # This ami instance should have python installed.
    user_data = <<-EOF
                #!/bin/bash
                cd /home/ubuntu
                echo "Hello, world" > index.html
                python -m SimpleHTTPServer "${var.server_port}"
                EOF

    tags {
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
}

output "public_ip" {
    value = "${aws_instance.web_server.public_ip}"
}

output "public_port" {
    value = "${var.server_port}"
}
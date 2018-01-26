provider "aws" {
    region = "us-east-1"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    #owners = ["099720109477"] # Canonical 
}

resource "aws_instance" "web_server" {
    ami             = "${data.aws_ami.ubuntu.id}"
    instance_type   = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    # Don't add spaces after EOF
    user_data = <<-EOF
                    #!/bin/bash
                    cd /home/ubuntu
                    echo "Hello, world<br/>" > index.html
                    echo "<br/>" >> index.html
                    date >> index.html
                    echo "<br/>" >> index.html
                    uname -n >> index.html
                    python -m SimpleHTTPServer 8080
                EOF

    tags {
        name = "myTag"
        Name = "Web-Server"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-web-server-security-group"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "public_ip" {
    value = "${aws_instance.web_server.public_ip}"
}

#This line add an elastic IP-Address to one instance
#This IP-Address is public, and should be associated to one instance.
# resource "aws_eip" "ip" {
#     instance = "${aws_instance.terraform_example.id}"
# }
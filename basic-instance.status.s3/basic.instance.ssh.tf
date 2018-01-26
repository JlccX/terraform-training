/*
The required command to allow us to use an s3 bucket folder to save the state file is:
terraform init \
 -backend-config="bucket=terraform-test-jose" \
 -backend-config="key=terraform.tfstate.backup" \
 -backend-config="key=terraform.tfstate" \
 -backend-config="region=us-east-1" \
 -backend-config="encrypt=true" 
*/

provider "aws" {
    region = "us-east-1"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

#ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20180110 (ami-33e4bc49)
resource "aws_instance" "web_server" {
    ami             = "ami-33e4bc49"
    instance_type   = "t2.micro"
    key_name        = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

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


terraform {
  backend "s3" {
    bucket  = "terraform-test-jose/status"
    key     = "terraform.tfstate,terraform.tfstate.backup"
    region  = "us-east-1"
    
  }

  lifecycle {
      prevent_destroy = true
  }
}


output "public_ip" {
    value = "${aws_instance.web_server.public_ip}"
}

output "public_port" {
    value = "${var.server_port}"
}
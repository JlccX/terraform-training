variable "vpc_id" {}

variable "subnet_id" {}

variable "name" {}

variable "stage_name" {}

variable "key_name" {}

variable "server_port" {}

variable "private_key_path" {}

variable "http_port" {}


resource "aws_security_group" "allow_http" {
    name            = "${var.name} allow http - terrafom tutorial"
    description     = "Allow HTTP traffic from anywhere"
    vpc_id          = "${var.vpc_id}"

    ingress {
        from_port   = "${var.http_port}"
        to_port     = "${var.http_port}"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "web-server" {
  ami               = "ami-33e4bc49"
  #image_id         = "ami-33e4bc49"
  instance_type     = "t2.micro"
  subnet_id         = "${var.subnet_id}"
  security_groups   = ["${aws_security_group.allow_http.id}"]
  key_name          = "${var.key_name}"
  associate_public_ip_address = true
  
  user_data = <<-EOF
                #!/bin/bash
                cd /home/ubuntu
                echo "Hello, world. <br/>Stage: ${var.stage_name}<br/>" > index.html
                echo "<br/>" >> index.html
                date >> index.html
                echo "<br/>" >> index.html
                uname -n >> index.html
                python -m SimpleHTTPServer "${var.server_port}"
              EOF

  connection {
        user        = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }

    tags {
        Name = "${var.name}"
    }
}







output "hostname" {
   value = "${aws_instance.web-server.private_dns}"
}

# output "addresses" {
#     value = "${aws_launch_configuration.examples.public_ip}"
# }

output "public_port" {
    value = "${var.server_port}"
}
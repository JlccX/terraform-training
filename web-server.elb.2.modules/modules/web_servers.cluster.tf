variable "name" {}
variable "elb_name" {}

provider "aws" {
    region = "us-east-1"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-33e4bc49"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name        = "JoseTest_KeyPair"
  
  user_data = <<-EOF
                #!/bin/bash
                cd /home/ubuntu
                echo "Hello, world<br/>" > index.html
                echo "Stage: ${var.name}<br/>" >> index.html
                echo "<br/>" >> index.html
                date >> index.html
                echo "<br/>" >> index.html
                uname -n >> index.html
                python -m SimpleHTTPServer 8080
              EOF
  lifecycle {
    create_before_destroy = true
  }

  connection {
        user        = "ubuntu"
        private_key = "/Users/jose.choque/AWS-KeyPairs/JoseTest_KeyPair.pem"
    }

}


resource "aws_security_group" "instance" {
    name            = "lan-security-group ${var.name}"
    description     = "Allow HTTP traffic from anywhere"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Opening SSH port
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones   = ["${data.aws_availability_zones.all.names}"]

    min_size = 2
    max_size = 10
    desired_capacity = 2

    load_balancers = ["${aws_elb.example.name}"]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "autoscaling ${var.name}"
        propagate_at_launch = true
    }
}

resource "aws_elb" "example" {
    name = "${var.elb_name}"
    security_groups = ["${aws_security_group.elb.id}"]
    availability_zones = ["${data.aws_availability_zones.all.names}"]

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 5
        interval = 300
        target = "HTTP:8080/"
    }

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = 8080
        instance_protocol = "http"
    }

    connection {
        user        = "ubuntu"
        private_key = "/Users/jose.choque/AWS-KeyPairs/JoseTest_KeyPair.pem"
    }

    tags {
        myTag = "aws-elb-instance ${var.name}"
        Name = "aws-elb ${var.name}"
    }
}

resource "aws_security_group" "elb" {
    name = "terraform-elb ${var.name}"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



output "elbs_dns_name" {
   value = "${aws_elb.example.dns_name}"
}

# output "addresses" {
#     value = "${aws_launch_configuration.examples.public_ip}"
# }

# output "public_port" {
#     value = "${var.server_port}"
# }
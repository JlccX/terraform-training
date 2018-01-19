variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "http_port" {
  description = "The port the server will use for HTTP requests"
  default     = 80
}

variable "ssh_port" {
  description = "The port the server will use for HTTP requests"
  default     = 22
}

variable "private_key_path" {
  default = "/Users/jose.choque/AWS-KeyPairs/JoseTest_KeyPair.pem"
}

variable "key_name" {
  default = "JoseTest_KeyPair"
}

variable "region_list" {
  description = "AWS availability zones."
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami-test" {
  type = "map"
  default = {
    us-east-1 = "ami-0d729a60"
    us-west-1 = "ami-7c4b331c"
  }
  description = "The AMIs to use."
}

variable "instance_ips" {
  description = "The IPs to use for our instances"
  default     = ["10.0.1.20","10.0.1.21"]
}


# resource "aws_instance" "base" {
#   ami = "${lookup(var.ami, var.region)}"
#   instance_type = "t2.micro"
# }

#var.ami[“us-west-1”]


#terraform plan -var 'access_key=abc123' -var 'secret_key=abc'

#terraform plan -var 'ami={ us-east-1 = "ami-0d729a60", us-west-1 = "ami-7c4b331c" }'

#terraform plan -var 'security_group_ids=["sg-4f713c35", "sg-4f713c35", "sg-4f713c35"]'

/*
here’s what the stage/services/webserver-cluster/user-data.sh script should look like:
#!/bin/bash
cat > index.html <<EOF
<h1>Hello, World</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF
nohup busybox httpd -f -p "${server_port}" &
Note that this Bash script has a few changes from the original:
*/
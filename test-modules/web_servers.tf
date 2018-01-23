

provider "aws" {
    region = "us-east-1"
    #access_key = "${var.access_key}"
    #secret_key = "${var.secret_key}"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
}


module "crazy_foods5" {
  source    = "./modules"
  #vpc_id    = "${aws_vpc.my_vpc.id}"
  #subnet_id = "${aws_subnet.public.id}"
  #name      = "CrazyFoods ${module.mighty_trousers.aws_security_group.allow_http.id}"
  #name      = "CrazyFoods"
  stage_name = "CrazyFoods"
  elb_name    = "CrazyFoods-elb"
  #key_name   = "JoseTest_KeyPair"
  #http_port  = "${var.http_port}"
  #server_port = 8080
  #private_key_path = "${var.private_key_path}"
}


/*
module "mighty_trousers2" {
  source    = "./modules"
  #vpc_id    = "${aws_vpc.my_vpc.id}"
  #subnet_id = "${aws_subnet.public.id}"
  #name      = "MightyTrousers"
  stage_name = "MightyTrousers"
  elb_name    = "MightyTrousers-elb"
  #key_name  = "JoseTest_KeyPair"
  #http_port  = "${var.http_port}"
  #server_port = 8080
  #private_key_path = "${var.private_key_path}"
}
*/
variable "region" {
  description = "The AWS region."
  default = "us-east-1"
}

variable "prefix" {
  description = "The name of our org, i.e. examplecom."
  default = "test.wfo.tools"
}

variable "environment" {
  description = "The name of our environment, i.e. development."
  default = "development"
}

variable "key_name" {
  description = "The AWS key pair to use for resources."
  default = "JoseTest_KeyPair"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC."
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default     = []
  description = "The list of public subnets to populate."
}

variable "private_subnets" {
  default     = []
  description = "The list of private subnets to populate."
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "private_key_path" {
  default = "/Users/jose.choque/AWS-KeyPairs/JoseTest_KeyPair.pem"
}

variable "key_name" {
  default = "JoseTest_KeyPair"
}

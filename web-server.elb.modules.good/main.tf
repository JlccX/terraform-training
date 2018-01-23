provider "aws" {
  region = "us-east-1"
}

module "developmentx" {
    source = "./modules/"
    name = "development"
}
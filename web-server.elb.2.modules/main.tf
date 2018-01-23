provider "aws" {
  region = "us-east-1"
}

# The elb_name value shouldn't contain weird characters because they don't allow to create the elb.

module "development" {
    source = "./modules/"
    name = "development"
    elb_name = "elb-development"
}


module "production" {
    source = "./modules/"
    name = "production"
    elb_name = "elb-production"
}
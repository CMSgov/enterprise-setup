locals {
  # UPDATE: set this to your stack (dev,prod,imp, etc)
  stack = "prod"

  # UPDATE: set this to the front facing fqdn of your installation
  fqdn = "circleci.west.cms.gov"
}

module "app" {
  source = "../../modules/cms"
  stack  = "${local.stack}"
  fqdn   = "${local.fqdn}"

  # CMS VPN = 52.20.26.200, 34.196.35.156
  # Remaining IPs are Github WebHooks https://help.github.com/en/articles/about-githubs-ip-addresses
  ingress_git_ips = ["192.30.252.0/22", "185.199.108.0/22", "140.82.112.0/20"]
  ingress_vpn_ips = ["52.20.26.200/32", "34.196.35.156/32"]
  
  # Optional, install an ssh key
  aws_ssh_key_name = "circleci"
}

module "proxy" {
  source   = "../../modules/ecr-proxy"
  stack    = "${local.stack}"
  alb_cert = "arn:aws:acm:us-west-2:249310508038:certificate/ff006c73-940a-420d-93a5-a15a5be88637"
}

#
# Proxy DNS Name
#
output "proxy_name" {
  value = "${module.proxy.alb_name}"
}

#
# Print out the ACM validation record
#
output "acm_validation" {
  value = "${module.app.domain_validation_options}"
}

#
# Print out the ELB dns name
#
output "elb_name" {
  value = "${module.app.elb_name}"
}

#
# Configure providers for this bootstrap. These are the latest versions as of 1/10/2019
#
provider "aws" {
  version = "~> 1.56.0"
  region  = "us-west-2"
}

provider "template" {
  version = "~> 1.0.0"
}

#
# Configure Terraform
#
terraform {
  required_version = "~> 0.11.11"

  backend "s3" {
    # UPDATE: set your bucket to the one created by the bootstrap module
    bucket = "aws-cms-oit-iusg-draas-circleci-prod-us-west-2-terraform"

    # UPDATE: set this to your environment name
    key = "circleci-prod/main.tfstate"

    dynamodb_table = "terraform-lock"
    region         = "us-west-2"
    encrypt        = "true"
  }
}

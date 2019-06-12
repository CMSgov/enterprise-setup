locals {
  # UPDATE: set this to your stack (dev,prod,imp, etc)
  stack       = "dev"
  application = "common-services"

  # UPDATE: set this to the front facing fqdn of your installation
  fqdn = "circleci-govcloud-dev.west.cms.gov"
}

module "app" {

  source       = "../../modules/cms"
  stack        = "${local.stack}"
  fqdn         = "${local.fqdn}"
  application  = "${local.application}"
  rds_instance = "db.m5.large"

  # CMS VPN = 52.20.26.200/32, 34.196.35.156/32
  # CMS Github Ent IP: 52.203.194.136/32
  ingress_git_ips = ["52.203.194.136/32"]
  ingress_vpn_ips = ["52.20.26.200/32", "34.196.35.156/32"]
  # Optional, install an ssh key
  aws_ssh_key_name = "circleci"
}

module "proxy" {
  source      = "../../modules/ecr-proxy"
  application = "${local.application}"
  stack    = "${local.stack}"
  alb_cert = "arn"
  ecs      = false
}
#
# Setup an ACM certificate for this environment
#
resource "aws_acm_certificate" "cert" {
  domain_name       = "ecr-proxy-govcloud-dev.west.cms.gov"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
output "proxy_acm_validation" {
  value = "${aws_acm_certificate.cert.domain_validation_options}"
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
# Proxy DNS Name
#
output "proxy_name" {
  value = "${module.proxy.alb_name}"
}

#
# Configure providers for this bootstrap. These are the latest versions as of 1/10/2019
#
provider "aws" {
  version = "~> 1.56.0"
  region  = "us-gov-west-1"
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
    bucket = "aws-cms-oit-iusg-gc-cs-dev-us-gov-west-1-terraform"

    # UPDATE: set this to your environment name
    key = "circleci-govcloud-dev/main.tfstate"

    dynamodb_table = "terraform-lock"
    region         = "us-gov-west-1"
    encrypt        = "true"
  }
}

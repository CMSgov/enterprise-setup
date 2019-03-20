locals {
  application = "circleci"
  prefix      = "${local.application}=${var.stack}"
}

data "aws_region" "current" {}

module "tags" {
  source      = "git@github.com:CMSgov/CMS-AWS-West-Pipelines.git//terraform/modules/cms-tags"
  application = "${local.application}"
  stack       = "${var.stack}"
}

module "network" {
  source      = "git@github.com:CMSgov/CMS-AWS-West-Pipelines.git//terraform/modules/network-v4"
  application = "${local.application}"
  stack       = "${var.stack}"
}

module "circleci" {
  source                   = "../../"
  aws_vpc_id               = ""
  aws_subnet_id            = ""
  aws_region               = "${data.aws_region.current.name}"
  aws_ssh_key_name         = ""
  circle_secret_passphrase = ""
}


#
# Load network metadata
#
module "network" {
  source      = "git@github.com:CMSgov/CMS-AWS-West-Pipelines//terraform/modules/network-v4"
  stack       = "${var.stack}"
  application = "${var.application}"
}

#
# Load Network tags
#
module "tags" {
  source      = "git@github.com:CMSgov/CMS-AWS-West-Pipelines//terraform/modules/cms-tags"
  stack       = "${var.stack}"
  application = "${var.application}"
}
#
# Create ECS cluster for adding fargate tasks into
#
resource "aws_ecs_cluster" "main" {
  count = "${var.ecs == 1 ? 1 : 0}"
  name = "${var.application}-${var.stack}"
  tags = "${module.tags.application_tags}"
}
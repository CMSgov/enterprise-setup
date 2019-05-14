#
# Go endpoint receives any traffic on /go-api/*
# listens on port 3000
# healthcheck on /health
#
module "ecr-proxy" {
  source = "git@github.com:CMSgov/CMS-AWS-West-Pipelines//terraform/modules/service-endpoint"

  # Application Configuration
  healthcheck_endpoint = "/health"
  app_port             = 3000
  path_pattern         = "/*"
  task                 = "ecr-proxy"
  priority             = 55

  # You should not have to modify stuff below here
  lb_listener_arn      = "${aws_lb_listener.front_end.id}"
  application          = "${var.application}"
  stack                = "${var.stack}"
  lb_security_group_id = "${aws_security_group.lb.id}"
  # Required as this is EC2/ASG
  #target_type = "instance"
}

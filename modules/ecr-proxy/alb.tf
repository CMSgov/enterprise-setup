#
# Configure an ALB to be used for this application and associated resources:
# - alb
# - ingress security group
# - listener with default 404 response.
#

resource "aws_lb" "lb" {
  name            = "${var.application}-${var.stack}-proxy-lb"
  subnets         = ["${module.network.private_subnet_ids}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

output "alb_name" {
  value = "${aws_lb.lb.dns_name}"
}

resource "aws_security_group" "lb" {
  name        = "${var.application}-${var.stack}-proxy-lb-ingress"
  description = "controls access to the ALB"
  vpc_id      = "${module.network.vpc_id}"
  tags        = "${module.tags.application_tags}"

  ingress {
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(module.tags.application_tags, map("Name","lb-ingress"))}"
}

# Explicit 404 on any unmapped URL paths.
resource "aws_lb_listener" "front_end" {
  count             = "${var.alb_cert == "" ? 0: 1}"
  load_balancer_arn = "${aws_lb.lb.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.alb_cert}"

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = 404
      content_type = "text/plain"
      message_body = "Not Found"
    }
  }
}

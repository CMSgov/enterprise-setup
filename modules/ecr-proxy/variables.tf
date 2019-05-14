variable "application" {
  default     = "circleci"
  description = "Application name"
}

variable "stack" {
  description = "Application stack (ie, dev, prod, imp)"
}

variable "alb_cert" {
  default = ""
}

variable "ecs" {
  default = true
}
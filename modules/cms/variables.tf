variable "stack" {
  type = "string"
}

variable "fqdn" {
  type = "string"
  description = "FQDN that this circle instance will listen on. Used to request an ACM certificate."
}

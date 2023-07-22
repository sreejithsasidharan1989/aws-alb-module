variable "project" {}
variable "environment" {}
variable "alb_switch" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "cert_switch" {}
variable "cert_arn" {}
variable "alb_ports" {
  type    = list(number)
  default = [80, 443]
}


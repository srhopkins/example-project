variable "region" {}
variable "env" {}

variable "cidr" {}

variable "azs" {
  type = "list"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

provider "aws" {
  version = "~> 1.7.1"
  region  = "${var.region}"
}

/* 
resource "aws_eip" "nat" {
  count = "${length(var.azs)}"

  vpc = true
}
 */

module "subnets" {
  source = "../subnet_calc"

  cidr_block = "${var.cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets = "${var.public_subnets}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-vpc"
  cidr = "${var.cidr}"

  azs             = ["${var.azs}"]
  private_subnets = ["${module.subnets.private_cidrs}"]
  public_subnets  = ["${module.subnets.public_cidrs}"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
  #external_nat_ip_ids = ["${aws_eip.nat.*.id}"]

  tags = {
    Terraform = "true"
    Environment = "${var.env}"
  }
}


output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "private_subnets_cidr_blocks" {
  value = "${module.vpc.private_subnets_cidr_blocks}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "public_subnets_cidr_blocks" {
  value = "${module.vpc.public_subnets_cidr_blocks}"
}
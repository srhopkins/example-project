variable "account" {}
variable "region" {}
variable "env" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "${var.account}-tfstate"
    key    = "aws/${var.env}/${var.region}/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ssh_keys" {
  backend = "s3"

  config {
    bucket = "${var.account}-tfstate"
    key    = "aws/${var.env}/${var.region}/ssh_keys/terraform.tfstate"
    region = "us-east-1"
  }
}

output "vpc_id" {
  value = "${data.terraform_remote_state.network.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${data.terraform_remote_state.network.vpc_cidr_block}"
}

output "private_subnets" {
  value = "${data.terraform_remote_state.network.private_subnets}"
}

output "private_subnets_cidr_blocks" {
  value = "${data.terraform_remote_state.network.private_subnets_cidr_blocks}"
}

output "public_subnets" {
  value = "${data.terraform_remote_state.network.public_subnets}"
}

output "public_subnets_cidr_blocks" {
  value = "${data.terraform_remote_state.network.public_subnets_cidr_blocks}"
}

####
# ssh_keys
####

output "key_name" {
    value = "${data.terraform_remote_state.ssh_keys.key_name}"
}

output "fingerprint" {
    value = "${data.terraform_remote_state.ssh_keys.fingerprint}"
}
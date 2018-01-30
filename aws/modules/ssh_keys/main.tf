variable "region" {}
variable "env" {}

variable "name" {}
variable "public_key" {}

provider "aws" {
  version = "~> 1.7.1"
  region  = "${var.region}"
}

resource "aws_key_pair" "this" {
  key_name   = "${var.env}-${var.region}-${var.name}"
  public_key = "${var.public_key}"
}

output "key_name" {
    value = "${aws_key_pair.this.key_name}"
}

output "fingerprint" {
    value = "${aws_key_pair.this.fingerprint}"
}
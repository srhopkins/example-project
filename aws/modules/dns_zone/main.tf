variable "domain_name" {}
provider "aws" {
  version = "~> 1.7.1"
  region  = "us-east-1"
}

resource "aws_route53_zone" "this" {
  name = "${var.domain_name}"
}

output "zone_id" {
    value = "${aws_route53_zone.this.zone_id}"
}

output "name_servers" {
    value = "${aws_route53_zone.this.name_servers}"
}
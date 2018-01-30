provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "kops" {
  name = "kops"
  path = "/service/"
}

resource "aws_iam_group" "kops" {
  name = "kops"
  path = "/groups/"
}

resource "aws_iam_group_membership" "kops" {
  name = "kops-membership"

  users = ["${aws_iam_user.kops.name}"]
  group = "${aws_iam_group.kops.name}"
}

resource "aws_iam_policy_attachment" "ec2" {
    groups     = ["${aws_iam_group.kops.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy_attachment" "route53" {
    role       = "${aws_iam_role.role.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
groups     = ["${aws_iam_group.group.name}"]
resource "aws_iam_policy_attachment" "s3" {
    groups     = ["${aws_iam_group.kops.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "iam" {
    groups     = ["${aws_iam_group.kops.name}"]
    policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_policy_attachment" "vpc" {
    groups     = ["${aws_iam_group.kops.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

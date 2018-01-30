output "cluster_name" {
  value = "steven.hopkins.rocks"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-steven-hopkins-rocks.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-steven-hopkins-rocks.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-steven-hopkins-rocks.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-steven-hopkins-rocks.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.us-east-1a-steven-hopkins-rocks.id}", "${aws_subnet.us-east-1b-steven-hopkins-rocks.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-steven-hopkins-rocks.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-steven-hopkins-rocks.name}"
}

output "region" {
  value = "us-east-1"
}

output "vpc_id" {
  value = "${aws_vpc.steven-hopkins-rocks.id}"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_attachment" "master-us-east-1a-masters-steven-hopkins-rocks" {
  elb                    = "${aws_elb.api-steven-hopkins-rocks.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-east-1a-masters-steven-hopkins-rocks.id}"
}

resource "aws_autoscaling_group" "master-us-east-1a-masters-steven-hopkins-rocks" {
  name                 = "master-us-east-1a.masters.steven.hopkins.rocks"
  launch_configuration = "${aws_launch_configuration.master-us-east-1a-masters-steven-hopkins-rocks.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-steven-hopkins-rocks.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "steven.hopkins.rocks"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-east-1a.masters.steven.hopkins.rocks"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-east-1a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-steven-hopkins-rocks" {
  name                 = "nodes.steven.hopkins.rocks"
  launch_configuration = "${aws_launch_configuration.nodes-steven-hopkins-rocks.id}"
  max_size             = 3
  min_size             = 3
  vpc_zone_identifier  = ["${aws_subnet.us-east-1a-steven-hopkins-rocks.id}", "${aws_subnet.us-east-1b-steven-hopkins-rocks.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "steven.hopkins.rocks"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.steven.hopkins.rocks"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-steven-hopkins-rocks" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "steven.hopkins.rocks"
    Name                 = "a.etcd-events.steven.hopkins.rocks"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-steven-hopkins-rocks" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "steven.hopkins.rocks"
    Name                 = "a.etcd-main.steven.hopkins.rocks"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_eip" "us-east-1a-steven-hopkins-rocks" {
  vpc = true
}

resource "aws_eip" "us-east-1b-steven-hopkins-rocks" {
  vpc = true
}

resource "aws_elb" "api-steven-hopkins-rocks" {
  name = "api-steven-hopkins-rocks-l0tma9"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-steven-hopkins-rocks.id}"]
  subnets         = ["${aws_subnet.utility-us-east-1a-steven-hopkins-rocks.id}", "${aws_subnet.utility-us-east-1b-steven-hopkins-rocks.id}"]

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "api.steven.hopkins.rocks"
  }
}

resource "aws_iam_instance_profile" "masters-steven-hopkins-rocks" {
  name = "masters.steven.hopkins.rocks"
  role = "${aws_iam_role.masters-steven-hopkins-rocks.name}"
}

resource "aws_iam_instance_profile" "nodes-steven-hopkins-rocks" {
  name = "nodes.steven.hopkins.rocks"
  role = "${aws_iam_role.nodes-steven-hopkins-rocks.name}"
}

resource "aws_iam_role" "masters-steven-hopkins-rocks" {
  name               = "masters.steven.hopkins.rocks"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.steven.hopkins.rocks_policy")}"
}

resource "aws_iam_role" "nodes-steven-hopkins-rocks" {
  name               = "nodes.steven.hopkins.rocks"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.steven.hopkins.rocks_policy")}"
}

resource "aws_iam_role_policy" "masters-steven-hopkins-rocks" {
  name   = "masters.steven.hopkins.rocks"
  role   = "${aws_iam_role.masters-steven-hopkins-rocks.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.steven.hopkins.rocks_policy")}"
}

resource "aws_iam_role_policy" "nodes-steven-hopkins-rocks" {
  name   = "nodes.steven.hopkins.rocks"
  role   = "${aws_iam_role.nodes-steven-hopkins-rocks.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.steven.hopkins.rocks_policy")}"
}

resource "aws_internet_gateway" "steven-hopkins-rocks" {
  vpc_id = "${aws_vpc.steven-hopkins-rocks.id}"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "steven.hopkins.rocks"
  }
}

resource "aws_key_pair" "kubernetes-steven-hopkins-rocks-42f8d43e876f5c42dee7024b8faaeeec" {
  key_name   = "kubernetes.steven.hopkins.rocks-42:f8:d4:3e:87:6f:5c:42:de:e7:02:4b:8f:aa:ee:ec"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.steven.hopkins.rocks-42f8d43e876f5c42dee7024b8faaeeec_public_key")}"
}

resource "aws_launch_configuration" "master-us-east-1a-masters-steven-hopkins-rocks" {
  name_prefix                 = "master-us-east-1a.masters.steven.hopkins.rocks-"
  image_id                    = "ami-8ec0e1f4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-steven-hopkins-rocks-42f8d43e876f5c42dee7024b8faaeeec.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-steven-hopkins-rocks.id}"
  security_groups             = ["${aws_security_group.masters-steven-hopkins-rocks.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-east-1a.masters.steven.hopkins.rocks_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-steven-hopkins-rocks" {
  name_prefix                 = "nodes.steven.hopkins.rocks-"
  image_id                    = "ami-8ec0e1f4"
  instance_type               = "t2.medium"
  key_name                    = "${aws_key_pair.kubernetes-steven-hopkins-rocks-42f8d43e876f5c42dee7024b8faaeeec.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-steven-hopkins-rocks.id}"
  security_groups             = ["${aws_security_group.nodes-steven-hopkins-rocks.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.steven.hopkins.rocks_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "us-east-1a-steven-hopkins-rocks" {
  allocation_id = "${aws_eip.us-east-1a-steven-hopkins-rocks.id}"
  subnet_id     = "${aws_subnet.utility-us-east-1a-steven-hopkins-rocks.id}"
}

resource "aws_nat_gateway" "us-east-1b-steven-hopkins-rocks" {
  allocation_id = "${aws_eip.us-east-1b-steven-hopkins-rocks.id}"
  subnet_id     = "${aws_subnet.utility-us-east-1b-steven-hopkins-rocks.id}"
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.steven-hopkins-rocks.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.steven-hopkins-rocks.id}"
}

resource "aws_route" "private-us-east-1a-0-0-0-0--0" {
  route_table_id         = "${aws_route_table.private-us-east-1a-steven-hopkins-rocks.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.us-east-1a-steven-hopkins-rocks.id}"
}

resource "aws_route" "private-us-east-1b-0-0-0-0--0" {
  route_table_id         = "${aws_route_table.private-us-east-1b-steven-hopkins-rocks.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.us-east-1b-steven-hopkins-rocks.id}"
}

resource "aws_route53_record" "api-steven-hopkins-rocks" {
  name = "api.steven.hopkins.rocks"
  type = "A"

  alias = {
    name                   = "${aws_elb.api-steven-hopkins-rocks.dns_name}"
    zone_id                = "${aws_elb.api-steven-hopkins-rocks.zone_id}"
    evaluate_target_health = false
  }

  zone_id = "/hostedzone/Z1WEQ7KERUFS3K"
}

resource "aws_route_table" "private-us-east-1a-steven-hopkins-rocks" {
  vpc_id = "${aws_vpc.steven-hopkins-rocks.id}"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "private-us-east-1a.steven.hopkins.rocks"
  }
}

resource "aws_route_table" "private-us-east-1b-steven-hopkins-rocks" {
  vpc_id = "${aws_vpc.steven-hopkins-rocks.id}"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "private-us-east-1b.steven.hopkins.rocks"
  }
}

resource "aws_route_table" "steven-hopkins-rocks" {
  vpc_id = "${aws_vpc.steven-hopkins-rocks.id}"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "steven.hopkins.rocks"
  }
}

resource "aws_route_table_association" "private-us-east-1a-steven-hopkins-rocks" {
  subnet_id      = "${aws_subnet.us-east-1a-steven-hopkins-rocks.id}"
  route_table_id = "${aws_route_table.private-us-east-1a-steven-hopkins-rocks.id}"
}

resource "aws_route_table_association" "private-us-east-1b-steven-hopkins-rocks" {
  subnet_id      = "${aws_subnet.us-east-1b-steven-hopkins-rocks.id}"
  route_table_id = "${aws_route_table.private-us-east-1b-steven-hopkins-rocks.id}"
}

resource "aws_route_table_association" "utility-us-east-1a-steven-hopkins-rocks" {
  subnet_id      = "${aws_subnet.utility-us-east-1a-steven-hopkins-rocks.id}"
  route_table_id = "${aws_route_table.steven-hopkins-rocks.id}"
}

resource "aws_route_table_association" "utility-us-east-1b-steven-hopkins-rocks" {
  subnet_id      = "${aws_subnet.utility-us-east-1b-steven-hopkins-rocks.id}"
  route_table_id = "${aws_route_table.steven-hopkins-rocks.id}"
}

resource "aws_security_group" "api-elb-steven-hopkins-rocks" {
  name        = "api-elb.steven.hopkins.rocks"
  vpc_id      = "${aws_vpc.steven-hopkins-rocks.id}"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "api-elb.steven.hopkins.rocks"
  }
}

resource "aws_security_group" "masters-steven-hopkins-rocks" {
  name        = "masters.steven.hopkins.rocks"
  vpc_id      = "${aws_vpc.steven-hopkins-rocks.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "masters.steven.hopkins.rocks"
  }
}

resource "aws_security_group" "nodes-steven-hopkins-rocks" {
  name        = "nodes.steven.hopkins.rocks"
  vpc_id      = "${aws_vpc.steven-hopkins-rocks.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "nodes.steven.hopkins.rocks"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-steven-hopkins-rocks.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-steven-hopkins-rocks.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.api-elb-steven-hopkins-rocks.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  source_security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-steven-hopkins-rocks.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-steven-hopkins-rocks.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1a-steven-hopkins-rocks" {
  vpc_id            = "${aws_vpc.steven-hopkins-rocks.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    KubernetesCluster                            = "steven.hopkins.rocks"
    Name                                         = "us-east-1a.steven.hopkins.rocks"
    "kubernetes.io/cluster/steven.hopkins.rocks" = "owned"
    "kubernetes.io/role/internal-elb"            = "1"
  }
}

resource "aws_subnet" "us-east-1b-steven-hopkins-rocks" {
  vpc_id            = "${aws_vpc.steven-hopkins-rocks.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                            = "steven.hopkins.rocks"
    Name                                         = "us-east-1b.steven.hopkins.rocks"
    "kubernetes.io/cluster/steven.hopkins.rocks" = "owned"
    "kubernetes.io/role/internal-elb"            = "1"
  }
}

resource "aws_subnet" "utility-us-east-1a-steven-hopkins-rocks" {
  vpc_id            = "${aws_vpc.steven-hopkins-rocks.id}"
  cidr_block        = "172.20.0.0/22"
  availability_zone = "us-east-1a"

  tags = {
    KubernetesCluster                            = "steven.hopkins.rocks"
    Name                                         = "utility-us-east-1a.steven.hopkins.rocks"
    "kubernetes.io/cluster/steven.hopkins.rocks" = "owned"
    "kubernetes.io/role/elb"                     = "1"
  }
}

resource "aws_subnet" "utility-us-east-1b-steven-hopkins-rocks" {
  vpc_id            = "${aws_vpc.steven-hopkins-rocks.id}"
  cidr_block        = "172.20.4.0/22"
  availability_zone = "us-east-1b"

  tags = {
    KubernetesCluster                            = "steven.hopkins.rocks"
    Name                                         = "utility-us-east-1b.steven.hopkins.rocks"
    "kubernetes.io/cluster/steven.hopkins.rocks" = "owned"
    "kubernetes.io/role/elb"                     = "1"
  }
}

resource "aws_vpc" "steven-hopkins-rocks" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                            = "steven.hopkins.rocks"
    Name                                         = "steven.hopkins.rocks"
    "kubernetes.io/cluster/steven.hopkins.rocks" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "steven-hopkins-rocks" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "steven.hopkins.rocks"
    Name              = "steven.hopkins.rocks"
  }
}

resource "aws_vpc_dhcp_options_association" "steven-hopkins-rocks" {
  vpc_id          = "${aws_vpc.steven-hopkins-rocks.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.steven-hopkins-rocks.id}"
}

terraform = {
  required_version = ">= 0.9.3"
}

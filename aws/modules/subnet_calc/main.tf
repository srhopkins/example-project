# helpful: https://fishingcatblog.wordpress.com/2016/09/22/terraform-interpolation-cidrsubnet/

variable "cidr_block" {
  type = "string"
}

variable "public_subnets" {
  description = "The number of total public subnets you want to intialize."

  default = {
    init = 2
    mask = 27
  }
}

variable "private_subnets" {
  description = "The number of total private subnets you want to intialize."

  default = {
    init = 2
    mask = 25
  }
}

variable "masks" {
  default = {
    "32" = 1
    "31" = 2
    "30" = 4
    "29" = 8
    "28" = 16
    "27" = 32
    "26" = 64
    "25" = 128
    "24" = 256
    "23" = 512
    "22" = 1024
    "21" = 2048
    "20" = 4096
    "19" = 8192
    "18" = 16384
    "17" = 32768
    "16" = 65536
    "15" = 131072
    "14" = 262144
    "13" = 524288
    "12" = 1048576
    "11" = 2097152
    "10" = 4194304
    "9"  = 8388608
    "8"  = 16777216
    "7"  = 33554432
    "6"  = 67108864
    "5"  = 134217728
    "4"  = 268435456
    "3"  = 536870912
    "2"  = 1073741824
    "1"  = 2147483648
    "0"  = 4294967296
  }
}

data "template_file" "cidr_mask" {
  template = "$${mask}"

  vars {
    mask = "${element(split("/", var.cidr_block), 1)}"
  }
}

data "template_file" "private" {
  template = "$${cidr_block}"
  count    = "${var.private_subnets["init"]}"

  vars {
    cidr_block = "${cidrsubnet(var.cidr_block,
      var.private_subnets["mask"] - data.template_file.cidr_mask.rendered,
      count.index
    )}"
  }
}

data "template_file" "public" {
  template = "$${cidr_block}"
  count    = "${var.public_subnets["init"]}"

  vars {
    cidr_block = "${cidrsubnet(var.cidr_block,
      var.public_subnets["mask"] - data.template_file.cidr_mask.rendered,
      (lookup(var.masks, data.template_file.cidr_mask.rendered) / (lookup(var.masks, var.public_subnets["mask"])) - (count.index + 1))
    )}"
  }
}

output "public_cidrs" {
  value = ["${data.template_file.public.*.rendered}"]
}

output "private_cidrs" {
  value = ["${data.template_file.private.*.rendered}"]
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "cidr_block_mask" {
  value = "${data.template_file.cidr_mask.rendered}"
}

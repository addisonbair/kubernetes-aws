variable "ami" {
  default = "ami-11fd2e71"
}

variable "az" {}

variable "env" {}

variable "instance_type" {
  default = "m3.large"
}

variable "snapshot_id" {
  default = "snap-0266788fbb0c9ed1b"
}

variable "vpn_subnet_cidr" {}

variable "project" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "igw_id" {}

variable "main_vpc_route_table_id" {}

variable "static_ip_range" {}

variable "route53_zone_id" {}

variable "ec2_pubkey" {}

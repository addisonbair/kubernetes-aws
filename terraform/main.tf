provider "aws" {
  access_key = "${var.access_key}"
  region     = "${var.region}"
  secret_key = "${var.secret_key}"
  token      = "${var.token}"
}

module "kubernetes" {
  source = "./kubernetes"

  ec2_pubkey             = "${var.ec2_pubkey}"
  fqdn                   = "${var.kube_fqdn}"
  kops_state_store       = "${var.kops_state_store}"
  kube_assets            = "${var.kube_assets}"
  master_ami             = "${var.kube_master_ami}"
  master_instance_type   = "${var.kube_master_instance_type}"
  master_subnet_id       = "${module.vpc.public_subnets[0]}"
  master_volume_size     = "${var.kube_master_volume_size}"
  nodes_ami              = "${var.kube_nodes_ami}"
  nodes_desired          = "${var.kube_nodes_desired}"
  nodes_instance_type    = "${var.kube_nodes_instance_type}"
  nodes_max              = "${var.kube_nodes_max}"
  nodes_min              = "${var.kube_nodes_min}"
  nodes_subnet_ids       = ["${module.vpc.public_subnets}"]
  nodes_volume_size      = "${var.kube_nodes_volume_size}"
  nodeup_url             = "${var.kube_nodeup_url}"
  protokube_image_source = "${var.protokube_image_source}"
  region                 = "${var.region}"
  vpc_id                 = "${module.vpc.vpc_id}"
}

module "vpc" {
  source = "./vpc"

  azs            = ["${var.vpc_azs}"]
  cidr           = "${var.vpc_cidr}"
  env            = "${var.env}"
  kube_fqdn      = "${var.kube_fqdn}"
  project        = "${var.project}"
  public_subnets = ["${var.vpc_public_subnet_cidrs}"]
  region         = "${var.region}"
}

module "vpn-gateway" {
  source = "./vpn-gateway"

  az                      = "${var.vpc_azs[0]}"
  ec2_pubkey              = "${var.ec2_pubkey}"
  env                     = "${var.env}"
  igw_id                  = "${module.vpc.igw_id}"
  main_vpc_route_table_id = "${module.vpc.public_route_table_id}"
  project                 = "${var.project}"
  route53_zone_id         = "${var.route53_zone_id}"
  static_ip_range         = "${var.vpn_static_ip_range}"
  vpc_cidr                = "${var.vpc_cidr}"
  vpc_id                  = "${module.vpc.vpc_id}"
  vpn_subnet_cidr         = "${var.vpn_subnet_cidr}"
}

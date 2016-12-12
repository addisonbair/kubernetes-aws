# AWS Provider
variable "access_key" {}

variable "region" {}

variable "secret_key" {}

variable "token" {}

# VPC
variable "env" {
  description = "The name of the environment being deployed. eg: testing, production, ci, etc."
}

variable "project" {
  description = "The name of the project being deployed"
}

variable "vpc_azs" {
  description = "A list of availability zones to deploy subnets in"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_cidr" {
  description = "The CIDR range of the VPC"
  default     = "172.16.0.0/16"
}

variable "vpc_public_subnet_cidrs" {
  description = "The CIDR ranges for the VPC's public subnets"
  default     = ["172.16.32.0/19", "172.16.64.0/19", "172.16.96.0/19"]
}

# Kubernetes - General
variable "kube_fqdn" {
  description = "Fully qualified domain name of cluster to deploy"
}

variable "kops_state_store" {
  description = "Name of s3 bucket containing kops cluster configurations"
}

variable "ec2_pubkey" {
  description = "Contents of public key to upload to AWS to access Master and nodes.
                    Make sure to have access to corresponding private key!"
}

# Kubernetes - Master
variable "kube_master_ami" {
  default = "ami-66884c06"
}

variable "kube_master_instance_type" {
  default = "m3.large"
}

variable "kube_master_volume_size" {
  default = 20
}

# Kubernetes - Nodes
variable "kube_nodes_ami" {
  default = "ami-66884c06"
}

variable "kube_nodes_instance_type" {
  default = "t2.medium"
}

variable "kube_nodes_volume_size" {
  default = 20
}

variable "kube_nodes_max" {
  default = 4
}

variable "kube_nodes_desired" {
  default = 3
}

variable "kube_nodes_min" {
  default = 2
}

# Kubernetes - User Data
variable "kube_assets" {
  description = "This populates the user-data for master and nodes with recent versions of kube"

  default = "- ee2556ce1d7fe0712191af1eef182c2a2a67f713@https://storage.googleapis.com/kubernetes-release/release/v1.4.3/bin/linux/amd64/kubelet
- c40cc0b66113314e33c74fa8c7ad1119f0ddccf6@https://storage.googleapis.com/kubernetes-release/release/v1.4.3/bin/linux/amd64/kubectl
- 86966c78cc9265ee23f7892c5cad0ec7590cec93@https://storage.googleapis.com/kubernetes-release/network-plugins/cni-8a936732094c0941e1543ef5d292a1f4fffa1ac5.tar.gz"
}

variable "kube_nodeup_url" {
  description = "Recent version for nodeup url for user-data"
  default     = "https://kubeupv2.s3.amazonaws.com/kops/1.4.1/linux/amd64/nodeup"
}

variable "protokube_image_source" {
  description = "Source for protokubeImage in user data for kube cluster"
  default = "kope/protokube:1.4"
}

# VPN Gateway
variable "vpn_static_ip_range" {
  description = "The IP range of the network behind the VPN"
  default     = "10.0.0.0/8"
}

variable "vpn_subnet_cidr" {
  description = "The CIDR to use for the VPN gateway subnet"
  default     = "172.16.3.0/28"
}

variable "route53_zone_id" {
  description = "The Zone ID to use for VPN DNS discovery"
}

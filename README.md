# How to run

## Terraform
Everything Terraform related is in `./terraform`

Deploying the entire infrastructure, as defined in `main.tf` using configuration specific to your environment that is defined in `vars.tfvars` is envoked using:

1) `$ terraform plan --var-file=vars.tfvars`

2) `$ terraform apply --var-file=vars.tfvars`

This will define and populate, with the help of `vars.tfvars` and `variables.tf` a 
development environment based upon Kubernetes, a VPC (AWS virtual private cloud) and 
a custom VPN gateway of my design (this allows access to a docker registry and self-hosted git repository to pull software releases 
behind a firewall).

However, we are also using a tool called `kops` (https://github.com/kubernetes/kops) that makes managing aspects of kubernetes much simpler than without. 
Before we run any terraform commands, we first define our cluster using `kops`:

`$ kops create cluster ${CLUSTER_NAME} --zones=us-west-2a,us-west-2b,us-west-2c`

After we run this, we run the terraform commands outlined above. Then we can invoke control over the kubernetes cluster with:

1) `$ kops export kubecfg ${CLUSTER_NAME}`

2) `$ kubectl describe services` (just an example of one such command to control the cluster we have just created, there are many others!)

## VPN Gateway
All the code used to enable the VPN tunnel is in `./vpn-gateway`

The configuration to deploy the VPN gateway is in `./terraform/vpn-gateway`

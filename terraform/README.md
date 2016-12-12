# Deploy infrastructure on AWS

## AWS Auth
This will automate most of the headache of authenticating against AWS.

```
$ cat ~/.aws/my-aws-account
#!/bin/bash
export AWS_ACCESS_KEY_ID=AKIA*********************
export AWS_SECRET_ACCESS_KEY=******************************
export AWS_DEFAULT_REGION=us-west-2
CREDS=$(aws sts get-session-token --serial-number arn:aws:iam::***************:mfa/user --token-code="$1")
export AWS_ACCESS_KEY_ID=$(echo $CREDS|jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS|jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $CREDS|jq -r .Credentials.SessionToken)
### TERRAFORM ENVARS
export TF_VAR_access_key=$AWS_ACCESS_KEY_ID
export TF_VAR_region=$AWS_DEFAULT_REGION
export TF_VAR_secret_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_token=$AWS_SESSION_TOKEN
```
`$ source ~/.aws/my-aws-account $MFA`

This will authenticate you for `kops`, `terraform` and `awscli` (if you need it for some reason)


## kops state store configuration and kops init
`kops` requires minimal setup. You point to an s3 bucket for kubernetes secrets/creds/kubeconfigs and specify a cluster FQDN.

`$ export KOPS_STATE_STORE=s3://domain-kops-store`

`$ export CLUSTER_NAME=kube.domain.com`

`${GOPATH}/bin/kops create cluster ${CLUSTER_NAME} --zones=us-west-2a,us-west-2b,us-west-2c`

`${GOPATH}/bin/kops update cluster ${CLUSTER_NAME} --target=terraform`

Remove the created `out/` directory as we will be providing our own, custom terraform config below
We still need to use `kops update` because it creates the credentials used to connect to the cluster


## Terraform variables and deploy
Using`vars.tfvars` set the requisite parameters for the variables in `variables.tf`

`$ cp vars.tfvars.example vars.tfvars`

`$ vim vars.tfvars`

`$ terraform get`

`$ terraform plan --var-file=vars.tfvars`

`$ terraform apply --var-file=vars.tfvars`


## Interacting with your new cluster
`${GOPATH}/bin/kops export kubecfg ${CLUSTER_NAME}`

`$ kubectl get nodes`

You’re good to go!


## Destroy Cluster
`$ terraform destroy --var-file=vars.tfvars`

`${GOPATH}/bin/kops delete ${CLUSTER_NAME} --yes`

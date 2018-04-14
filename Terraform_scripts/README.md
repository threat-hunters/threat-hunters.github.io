Terraform scripts for deploying Project18 in AWS

Pre-requisite:
1. AWS account with command line access (Access ID & Key) and appropriate permissions.
2. AWS-CLI installed & configured to use the Access ID & Key.
3. Terraform installed from https://www.terraform.io/downloads.html

To deploy the terraform code, go into the directory and do the following:
1. terragform get 
2. terraform init (Required to be done only the 1st time you try to deploy using the code).
2. terraform validate
3. Execute script deploy.sh

To destroy the infrastructure, use the command "terraform destroy"



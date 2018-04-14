#!/bin/bash
if [ ! -f ./ssh/capstone_key.pub ]; then
ssh-keygen -b 4096 -f ./ssh/capstone_key -t rsa 
else
echo "Using key capstone_key.pub in the terraform scripts"
echo
fi

pub_key=$(grep -A 2 "public_key" ./variables.tf| grep default| cut -d '"' -f2)

if [-z $pub_key]; then
pub_key=$(cat ssh/capstone_key.pub)
line_number=$(($(grep -n "public_key" ./variables.tf|cut -d ":" -f1)+2))
sed -ie "$line_number"d ./variables.tf
sed -ie $line_number'i''    default = '$pub_key ./variables.tf
fi

terraform init
terraform validate
terraform apply -target=module.Command_and_Control -auto-approve
terraform apply -auto-approve



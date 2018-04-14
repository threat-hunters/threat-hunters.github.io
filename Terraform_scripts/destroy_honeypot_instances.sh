#! /bin/bash

terraform destroy -force -target=module.honeypot-us.aws_instances.*
terraform destroy -force -target=module.honeypot-ap-northeast.aws_instances.*
terraform destroy -force -target=module.honeypot-ap-south.aws_instances.*
terraform destroy -force -target=module.honeypot-ap-southeast.aws_instances.*
terraform destroy -force -target=module.honeypot-sa.aws_instances.*
terraform destroy -force -target=module.honeypot-eu.aws_instances.*

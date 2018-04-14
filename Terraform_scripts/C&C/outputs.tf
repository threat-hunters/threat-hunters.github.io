output "mhn_private_ip" {
	description = "MHN_Private_IP"
	value = "${aws_instance.mhn.private_ip}"
}

output "mhn_deploy_key" {
	description = "MHN Deploy Key"
	value = "${random_string.mhn_deploy_key.result}"
}

output "route_table_private_id" {
	description = "Routing table ID of Private VPC"
	value = "${aws_route_table.route_table_private.id}"
}

output "vpc_private_domain_id" {
	description = "VPC Private ID"
	value = "${aws_vpc.vpc_private_domain.id}"
}

#Declaring variables for Private VPC Setup
																																																																																																																																																							
variable "private_region" {
	description = "Region to setup Pfsense, MHN, Splunk and Suricata"
}

variable "vpc_private_cidr" {
	description = "Private CIDR for ThreatHunter Private VPC"
}

variable "vpc_private_subnet" {
	description = "VPC Private Subnet for ThreatHunter"
}

variable "company_ip" {
	description = "Public IP of Company"
	type = "list"
}

variable "private_ips_honeypots_cidr_range" {
	description = "VPC CIDR Range for honeypot for different regions"
	type = "list"
}

variable "universal_key" {
	description	= "Key to connect to EC2 instances"
}

variable "mhn_server_variables" {
description = "MHN Server Variables"
type = "map"
default = {
	"password" = "supersecure"
	"email"	 = "best@husky.com"
	"splunk_port" = "9997"
	}
}

variable "splunk_server_variables" {
	description = "Splunk Server Variables"
	type = "map"
	default = {
		"password" = "supersecure"
	}
}

/* Network Interface IPs */
#"mhn"		= "${cidrhost(var.vpc_private_subnet,4)}"
#"splunk" 	= "${cidrhost(var.vpc_private_subnet,5)}"
#"suricata" 	= "${cidrhost(var.vpc_private_subnet,6)}"
	

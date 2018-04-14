#Declaring variables for honeypot

variable "honeypot_region" {
	description = "AWS Region to deploy Honeypot"
}

variable "vpc_honeypot_cidr" {
	description = "Private IP Address for HoneypotVPC"	
}

variable "vpc_honeypot_subnet" {
	description = "VPC Honeypot Subnet"
}

variable "vpc_private_cidr" {
	description = "Private CIDR for ThreatHunter Private VPC"
}

variable "vpc_private_subnet" {
	description = "VPC Public Subnet for ThreatHunter"
}

variable "vpc_private_domain_id" {
	description = "Private VPC ID for ThreatHunter Private VPC"
}

variable "honeypot_peer_region" {
	description = "Region to connect to ThreatHunter Private VPC"
}

variable "company_ip" {
	description = "Public IP of Company or project members"
	type	    = "list"
}

variable "mhn_ip" {
	description = "MHN IP"	
}

variable "mhn_deploy_code" {
	description = "Deploy code to used to create honeypots"
}

variable "universal_key" {
	description = "Public Key to connect to all honeypots"
}

variable "instance_name" {
	description = "The type of honeypot"
	type = "list"
	default = ["Shockpot Sinkhole","Dionaea with HTTP", "None", "Dionaea", "Cowrie", "Snort", "Amun", "ElasticHoney", "Glastopf", "Suricata","p0f", "Shockpot", "Wordpot", "Conpot"]
}



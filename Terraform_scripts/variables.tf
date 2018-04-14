variable "credential_file" {
	description = "AWS credential file to be used to use terraform (Default profile)"
	default = "~/.aws/credentials"
}

variable "private_region" {
	description	= "Region to setup Pfsense, MHN, Splunk and Suricata"
	default		= "us-east-1"
}

variable "vpc_private_cidr" {
	description = "Private CIDR for ThreatHunter Private VPC"
	default     = "192.168.1.0/24"
}

variable "vpc_private_subnet" {
	description = "VPC Private Subnet for ThreatHunter"
	default     = "192.168.1.0/28"
}

variable "honeypot_regions" {
	description	= "Regions to deploy honeypots"
	type 		= "list"
	default 	= ["us-west-1", "ap-northeast-1", "ap-south-1", "ap-southeast-1", "sa-east-1", "eu-west-2"]
}

variable "private_ips_honeypots_cidr" {
	description = "VPC CIDR for honeypot for different regions"
	type	= "list"
	default = ["192.168.2.0/24","192.168.3.0/24","192.168.4.0/24","192.168.5.0/24","192.168.6.0/24","192.168.7.0/24"]
}

variable "private_ips_honeypots_subnet" {
	description = "VPC Subnet for honeypot for different regions"
	type	= "list"
	default = ["192.168.2.0/26","192.168.3.0/26","192.168.4.0/26","192.168.5.0/26","192.168.6.0/26","192.168.7.0/26"]
}

variable "private_ips_honeypots_cidr_range" {
	description = "VPC CIDR for honeypot for different regions"
	type	= "list"
	default = ["192.168.2.0/23","192.168.4.0/22"]
}

variable "public_key" {
	description	= "Key to connect to EC2 instances"
	default		= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDxB0XbV8kRLv3740/GYGBIQnH2MA4DLIkK4UW70X4NllreZNwZqvzj0N9u1h6sGRVmugz93CpzmSsPjsBv3AUhoL3AQNs/wt061ZzepvfMES1wLcI8UbJzT8xnoNdtBQd0p1db66u1jIe3YL0Kb+mvGTrs+JBYC4dwYI8vG14Dkjy5qU083BKyJAD3oUu69YBiqxHZMEuxDSmhVySA9x87VHXR2ptCYbjN9vX6Wbs/EO18Yj1Rha3QBXgCYit8J3bS1X33dpm7o3ZwZmNtZXkRzO5d3NC95Q4ZPiDoYVYYLgANiE18mGPiJRz2zfN75kzSsB/hPW81h4zYSr5hkFBmHDjGUXI5DmMF1U8yAEZR3Kbj6elyd/kHtsxAqDwr3lR3WtWh0b6w2bZMKEn3HH6ZHuxImsX2zGQcRGx4AxmHryoHnTHUYWbuMxVEpSEtpBi/LXbTNd+zqmxdRRdhF8d7y3+NATiJf44iY+2rVq/tFSO9Le5nAHP/voXNqjDt8hm5EHvQJE+zKKLCy1e9Q6aGe6Jug6vSASyeAMv8ntzDTfUbZ6Lxx9JUJnYeL0AxPiAX2TOctM2M3vfLGMnbuwK2dyAvv0F/WCIP4mPF7Gd8hotoJFmuhIJaf5TXwF3Qo457/xWXb+W5LD1MIoNT97zsepmmBvAdyCMq5VYhmG9RLQ== root@kali"
}

variable "company_ip" {
	description = "Public IP of Company"
	type	= "list"
	default = ["73.47.31.220/32","64.112.177.2/32","98.217.74.238/32","129.10.0.0/16","155.33.0.0/16"]
}



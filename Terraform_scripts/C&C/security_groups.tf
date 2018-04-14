#Declare security groups that need to be associated with the project

resource "aws_security_group" "suricata_sg" {
	name = "ThreatHunter Suricata-Honeypots"
	tags {
       		Name = "ThreatHunter Suricata Honeypot & Private ACL"
  	}
  	description = "Traffic between Suricata & Honeypots; Company & Suricata ;for Suricata"
  	vpc_id = "${aws_vpc.vpc_private_domain.id}"

	egress {
    		from_port = 2514
    		to_port = 2514
    		protocol = "-1"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
	}
	ingress {
		from_port = 22
    		to_port = 22
    		protocol = "TCP"
    		cidr_blocks = "${var.company_ip}"
	}
	egress {
    		from_port = 0
    		to_port = 0
    		protocol = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "mhn_sg" {
	name = "ThreatHunter MHN"
	tags {
       		Name = "ThreatHunter MHN ACL"
  	}
	vpc_id = "${aws_vpc.vpc_private_domain.id}"
	ingress {
        	from_port = 3000
    		to_port = 3000
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 6379
    		to_port = 6379
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 8089
    		to_port = 8089
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 8181
    		to_port = 8181
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 10000
    		to_port = 10000
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 27017
    		to_port = 27017
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 80
    		to_port = 80
    		protocol = "TCP"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 22
    		to_port = 22
    		protocol = "TCP"
    		cidr_blocks = "${var.company_ip}"
	}
	ingress {
        	from_port = 80
    		to_port = 80
    		protocol = "TCP"
    		cidr_blocks = "${var.company_ip}"
	}
}

resource "aws_security_group" "splunk_sg" {
	name = "ThreatHunter Splunk"
	tags {
       		Name = "ThreatHunter Splunk ACL"
  	}
	vpc_id = "${aws_vpc.vpc_private_domain.id}"
	ingress {
        	from_port = 0
    		to_port = 0
    		protocol = "-1"
    		cidr_blocks = "${var.private_ips_honeypots_cidr_range}"
  	}
	ingress {
        	from_port = 8000
    		to_port = 8000
    		protocol = "TCP"
    		cidr_blocks = "${var.company_ip}"
	}
	ingress {
        	from_port = 22
    		to_port = 22
    		protocol = "TCP"
    		cidr_blocks = "${var.company_ip}"
	}
        ingress {
		from_port = 9997
    		to_port = 9997
    		protocol = "TCP"
    		cidr_blocks = ["${cidrhost(var.vpc_private_subnet,4)}/32"]
	}
	ingress {
		from_port = 8089
    		to_port = 8089
    		protocol = "TCP"
    		cidr_blocks = ["${cidrhost(var.vpc_private_subnet,4)}/32","${cidrhost(var.vpc_private_subnet,6)}/32"]
	}
	ingress {
		from_port = 514
    		to_port = 514
    		protocol = "TCP"
    		cidr_blocks = ["${cidrhost(var.vpc_private_subnet,4)}/32"]
	}
	ingress {
		from_port = 514
    		to_port = 514
    		protocol = "UDP"
    		cidr_blocks = ["${cidrhost(var.vpc_private_subnet,4)}/32"]
	}
}

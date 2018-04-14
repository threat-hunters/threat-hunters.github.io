# Setting up AWS VPC and other networking details for Honeypots

provider "aws" {
	region 	   = "${var.honeypot_region}"
}

resource "aws_vpc" "vpc_honeypot" {
	cidr_block = "${var.vpc_honeypot_cidr}"
	tags {
		Name = "ThreatHunter Honeypot VPC"
	}
}

/* Define Gateway for VPC */
resource "aws_internet_gateway" "vpc_honeypot_gw" {
	vpc_id = "${aws_vpc.vpc_honeypot.id}"
	tags {
        	Name = "ThreatHunter VPC Honeypot Gateway"
	}
}

resource "aws_vpc_peering_connection" "vpc_peer_honeypot-priv" {
	vpc_id 		= "${aws_vpc.vpc_honeypot.id}"
	peer_vpc_id 	= "${var.vpc_private_domain_id}"
	peer_region 	= "${var.honeypot_peer_region}"
	tags {
		Name 	= "ThreatHunter VPC Peering Honeypot to Private"
	}
}

resource "aws_route_table" "route_table_honeypot" {
	vpc_id 		= "${aws_vpc.vpc_honeypot.id}"
	tags {
		Name 	= "ThreatHunter VPC Honeypot Public"
	}
}

resource "aws_route" "internet_route-honeypot" {
	route_table_id 		= "${aws_route_table.route_table_honeypot.id}"
	destination_cidr_block 	= "0.0.0.0/0"
	gateway_id 		= "${aws_internet_gateway.vpc_honeypot_gw.id}"
	depends_on      	= ["aws_route_table.route_table_honeypot"]
}

resource "aws_route" "route_private_honeypot" {
	route_table_id 			= "${aws_route_table.route_table_honeypot.id}"
	destination_cidr_block 		= "${var.vpc_private_cidr}"
	vpc_peering_connection_id 	= "${aws_vpc_peering_connection.vpc_peer_honeypot-priv.id}"
	depends_on      		= ["aws_route_table.route_table_honeypot"]
}

/*Create Subnet for Honeypot VPC*/
resource "aws_subnet" "vpc_honeypot_subnet" {
	vpc_id 		= "${aws_vpc.vpc_honeypot.id}"
	cidr_block 	= "${var.vpc_honeypot_subnet}"
	tags {
		Name 	= "ThreatHunter VPC Honeypot Subnet"
	}
}

/*Attach Subnet in Honeypot VPC to default routing table*/
resource "aws_route_table_association" "honeypot_subnet_association_route_table" {
	subnet_id 	= "${aws_subnet.vpc_honeypot_subnet.id}"
	route_table_id 	= "${aws_route_table.route_table_honeypot.id}"
}

/* Define VPC level ACLs */
resource "aws_default_network_acl" "honeypot_vpc_acl" {
   default_network_acl_id = "${aws_vpc.vpc_honeypot.default_network_acl_id}"
    egress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "ThreatHunter Honeypot VPC ACL"
    }
}

output "vpc_peer_honeypot-priv_id" {
	description = "VPC Peer ID"
	value = "${aws_vpc_peering_connection.vpc_peer_honeypot-priv.id}"
}

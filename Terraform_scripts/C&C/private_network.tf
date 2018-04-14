# Setting up AWS VPC and other networking details

provider "aws" {
	region  = "${var.private_region}"
}

/*Define Private VPC */
resource "aws_vpc" "vpc_private_domain" {
    cidr_block 	= "${var.vpc_private_cidr}"
    tags {
      Name 	= "ThreatHunter Private VPC"
    }
}

/* Define Internet Gateway for Private VPC */
resource "aws_internet_gateway" "vpc_private_internet_gw" {
	vpc_id 		= "${aws_vpc.vpc_private_domain.id}"
	tags {
        	Name 	= "ThreatHunter VPC Private Internet Gateway"
	}
}

/*Add routing table for Private VPC */
resource "aws_route_table" "route_table_private" {
	vpc_id 		= "${aws_vpc.vpc_private_domain.id}"
	tags {
		Name 	= "ThreatHunter VPC Private"
	}
}

resource "aws_route" "internet_route-private" {
	route_table_id 		= "${aws_route_table.route_table_private.id}"
	destination_cidr_block 	= "0.0.0.0/0"
	gateway_id 		= "${aws_internet_gateway.vpc_private_internet_gw.id}"
	depends_on      	= ["aws_route_table.route_table_private"]
}
	
/*Create Subnet for Private VPC */
resource "aws_subnet" "vpc_private_subnet" {
	vpc_id 		= "${aws_vpc.vpc_private_domain.id}"
	cidr_block 	= "${var.vpc_private_subnet}"
	availability_zone= "us-east-1a"
	tags {
		Name 	= "ThreatHunter VPC Private Subnet"
	}
}

/*Attach Subnet in Private VPC to default routing table*/
resource "aws_route_table_association" "private_subnet_association_route_table" {
	subnet_id 	= "${aws_subnet.vpc_private_subnet.id}"
	route_table_id 	= "${aws_route_table.route_table_private.id}"
}

/* Define VPC level ACLs */
resource "aws_default_network_acl" "private_vpc_acl" {
    default_network_acl_id = "${aws_vpc.vpc_private_domain.default_network_acl_id}"
    egress {
        protocol 	= "-1"
        rule_no 	= 1
        action 		= "allow"
        cidr_block 	= "0.0.0.0/0"
        from_port 	= 0
        to_port 	= 0
    }
    ingress {
        protocol 	= "-1"
        rule_no 	= 1
        action 		= "allow"
        cidr_block 	= "0.0.0.0/0"
        from_port 	= 0
        to_port 	= 0
    }
    tags {
        Name 		= "ThreatHunter Private VPC ACL"
    }
}

/*Create 2nd network interface for Suricata 
resource "aws_network_interface" "suricata_honeypots_ENI" {
	subnet_id 		= "${aws_subnet.vpc_private_subnet.id}"
	private_ips 		= ["${cidrhost(var.vpc_private_subnet,7)}"]
	#security_groups 	= ["${aws_security_group.suricata_honeypots_private_sg.id}"]
	attachment {
    		instance 	= "${aws_instance.suricata.id}"
		device_index 	= 1
	}
	description 		= "Suricata Honeypots Interface for Suricata"
	tags = {
		Name 		= "ThreatHunter Suricata Honeypots Network Interface"
	}
}*/

/*Attach ACL or security group to secondary network interface for suricata 
resource "aws_network_interface_sg_attachment" "sg_attachment_suricata_honeypot" {
	security_group_id    = "${aws_security_group.suricata_honeypots_private_sg.id}"
	network_interface_id = "${aws_network_interface.suricata_honeypots_ENI.id}"
}*/

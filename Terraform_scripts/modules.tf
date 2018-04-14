provider "aws" {
	shared_credentials_file   = "${var.credential_file}"
	region   		  = "${var.private_region}"
	profile			  = "default"
}

module "Command_and_Control" {
	source	   		  = "./C&C"
	private_region 	  	  = "${var.private_region}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	universal_key 		  = "${var.public_key}"
	private_ips_honeypots_cidr_range = "${var.private_ips_honeypots_cidr_range}"
	company_ip 	          = "${var.company_ip}"
}

module "honeypot-us" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[0]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[0]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[0]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
	
}

/*Accept VPC Peer connections from Honeypot US region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-0" {
	vpc_peering_connection_id = "${module.honeypot-us.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

	tags {
    		Name = "ThreatHunter Honeypot California"
	}
}

/*Create route from Private VPC to Honeypot VPC US via VPC Peer */
resource "aws_route" "honeypot-us-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[0]}"
	vpc_peering_connection_id = "${module.honeypot-us.vpc_peer_honeypot-priv_id}"
}


module "honeypot-ap-northeast" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[1]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[1]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[1]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
}

/*Accept VPC Peer connections from Honeypot Tokyo region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-1" {
	vpc_peering_connection_id = "${module.honeypot-ap-northeast.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

	tags {
	    	Name = "ThreatHunter Honeypot Tokyo"
	}
}

/*Create route from Private VPC to Honeypot VPC Tokyo via VPC Peer */
resource "aws_route" "honeypot-ap-northeast-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[1]}"
	vpc_peering_connection_id = "${module.honeypot-ap-northeast.vpc_peer_honeypot-priv_id}"
}

module "honeypot-ap-south" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[2]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[2]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[2]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
}

/*Accept VPC Peer connections from Honeypot Mumbai region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-2" {
	vpc_peering_connection_id = "${module.honeypot-ap-south.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

	tags {
	    	Name = "ThreatHunter Honeypot Mumbai"
	}
}

/*Create route from Private VPC to Honeypot VPC Mumbai via VPC Peer */
resource "aws_route" "honeypot-ap-south-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[2]}"
	vpc_peering_connection_id = "${module.honeypot-ap-south.vpc_peer_honeypot-priv_id}"
}


module "honeypot-ap-southeast" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[3]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[3]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[3]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
}

/*Accept VPC Peer connections from Honeypot Singapore region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-3" {
	vpc_peering_connection_id = "${module.honeypot-ap-southeast.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

  tags {
    	Name = "ThreatHunter Honeypot Singapore"
  }
}

/*Create route from Private VPC to Honeypot VPC Singapore via VPC Peer */
resource "aws_route" "honeypot-ap-southeast-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[3]}"
	vpc_peering_connection_id = "${module.honeypot-ap-southeast.vpc_peer_honeypot-priv_id}"
}

module "honeypot-sa" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[4]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[4]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[4]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
}

/*Accept VPC Peer connections from Honeypot Sao Paulo region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-4" {
	vpc_peering_connection_id = "${module.honeypot-sa.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

	tags {
		Name	= "ThreatHunter Honeypot Sao Paulo"
  	}
}

/*Create route from Private VPC to Honeypot VPC Sao Paulo via VPC Peer */
resource "aws_route" "honeypot-sa-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[4]}"
	vpc_peering_connection_id = "${module.honeypot-sa.vpc_peer_honeypot-priv_id}"
}

module "honeypot-eu" {
	source	   		  = "./honeypots"
	honeypot_region	   	  = "${var.honeypot_regions[5]}"
	honeypot_peer_region 	  = "${var.private_region}"
	vpc_honeypot_cidr 	  = "${var.private_ips_honeypots_cidr[5]}"
	vpc_honeypot_subnet 	  = "${var.private_ips_honeypots_subnet[5]}"
	vpc_private_cidr 	  = "${var.vpc_private_cidr}"
	vpc_private_subnet  	  = "${var.vpc_private_subnet}"
	vpc_private_domain_id 	  = "${module.Command_and_Control.vpc_private_domain_id}"
	mhn_ip 			  = "${module.Command_and_Control.mhn_private_ip}"
	mhn_deploy_code 	  = "${module.Command_and_Control.mhn_deploy_key}"
	universal_key 		  = "${var.public_key}"
	company_ip 		  = "${var.company_ip}"
}

/*Accept VPC Peer connections from Honeypot London region */
resource "aws_vpc_peering_connection_accepter" "honeypot-peer-5" {
	vpc_peering_connection_id = "${module.honeypot-eu.vpc_peer_honeypot-priv_id}"
	auto_accept               = true

	tags {
		Name	= "ThreatHunter Honeypot London"
  	}
}

/*Create route from Private VPC to Honeypot VPC London via VPC Peer */
resource "aws_route" "honeypot-eu-private" {
	route_table_id 		  = "${module.Command_and_Control.route_table_private_id}"
	destination_cidr_block 	  = "${var.private_ips_honeypots_cidr[5]}"
	vpc_peering_connection_id = "${module.honeypot-eu.vpc_peer_honeypot-priv_id}"
}



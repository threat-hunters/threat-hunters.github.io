/* Declare security groups that need to be associated with the honeypots */
resource "aws_security_group" "honeypots_allow_sg" {
	name = "ThreatHunter Allow All"
	tags {
       		Name = "ThreatHunter Allow All Traffic"
  	}
  	description = "For connection between world and honeypot"
  	vpc_id = "${aws_vpc.vpc_honeypot.id}"
	ingress {
        	from_port = 0
    		to_port = 0
    		protocol = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}	
}

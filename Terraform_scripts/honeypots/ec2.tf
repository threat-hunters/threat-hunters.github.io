#Create honeypot instances

resource "aws_instance" "honeypot-1" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.micro"
  	associate_public_ip_address 	= "true"
  	subnet_id 			= "${aws_subnet.vpc_honeypot_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_honeypot_subnet,4)}"
	vpc_security_group_ids		= ["${aws_security_group.honeypots_allow_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.honeypot-1.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./honeypots/scripts/sensor.sh"
    		destination = "/tmp/sensor.sh"
  	}
	provisioner "remote-exec" {
		inline 	= [
			"sudo chmod u+x /tmp/sensor.sh",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 4",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 5",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 10",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 11",
			"sudo rm -f /tmp/sensor.sh"
		]
	}
	provisioner "remote-exec" {
		script 			= "./honeypots/scripts/honeypot_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_accepter.conf"
    		destination = "/tmp/suricata_rules_accepter.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_accepter.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sleep 30",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 	= "Dionaea,Cowrie,Suricata,p0f"
  	}
}

resource "aws_instance" "honeypot-2" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.micro"
  	associate_public_ip_address 	= "true"
  	subnet_id 			= "${aws_subnet.vpc_honeypot_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_honeypot_subnet,5)}"
	vpc_security_group_ids		= ["${aws_security_group.honeypots_allow_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.honeypot-2.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./honeypots/scripts/sensor.sh"
    		destination = "/tmp/sensor.sh"
  	}
	provisioner "remote-exec" {
		inline 	= [
			"sudo chmod u+x /tmp/sensor.sh",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 5",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 10",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 7",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 11",
			"sudo rm -f /tmp/sensor.sh"
		]
	}
	provisioner "remote-exec" {
		script 	= "./honeypots/scripts/honeypot_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_accepter.conf"
    		destination = "/tmp/suricata_rules_accepter.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_accepter.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sleep 30",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 	= "Amun,Cowrie,Suricata,p0f"
  	}
}

resource "aws_instance" "honeypot-3" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.micro"
  	associate_public_ip_address 	= "true"
  	subnet_id 			= "${aws_subnet.vpc_honeypot_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_honeypot_subnet,6)}"
	vpc_security_group_ids		= ["${aws_security_group.honeypots_allow_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.honeypot-3.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./honeypots/scripts/sensor.sh"
    		destination = "/tmp/sensor.sh"
  	}
	provisioner "remote-exec" {
		inline 	= [
			"sudo chmod u+x /tmp/sensor.sh",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 1",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 10",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 8",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 11",
			"sudo rm -f /tmp/sensor.sh"
		]
	}
	provisioner "remote-exec" {
		script 	= "./honeypots/scripts/honeypot_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_accepter.conf"
    		destination = "/tmp/suricata_rules_accepter.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_accepter.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sleep 30",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 	= "ElasticHoney,Shockpot,Suricata,p0f"
  	}
}

resource "aws_instance" "honeypot-4" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.micro"
  	associate_public_ip_address 	= "true"
  	subnet_id 			= "${aws_subnet.vpc_honeypot_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_honeypot_subnet,7)}"
	vpc_security_group_ids		= ["${aws_security_group.honeypots_allow_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.honeypot-4.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./honeypots/scripts/sensor.sh"
    		destination = "/tmp/sensor.sh"
  	}
	provisioner "remote-exec" {
		inline 	= [
			"sudo chmod u+x /tmp/sensor.sh",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 10",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 11",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 14",
			"sudo rm -f /tmp/sensor.sh"
		]
	}
	provisioner "remote-exec" {
		script 	= "./honeypots/scripts/honeypot_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_accepter.conf"
    		destination = "/tmp/suricata_rules_accepter.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_accepter.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sleep 30",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 	= "Conpot,Suricata,p0f"
  	}
}

resource "aws_instance" "honeypot-5" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.micro"
  	associate_public_ip_address 	= "true"
  	subnet_id 			= "${aws_subnet.vpc_honeypot_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_honeypot_subnet,8)}"
	vpc_security_group_ids		= ["${aws_security_group.honeypots_allow_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.honeypot-5.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./honeypots/scripts/sensor.sh"
    		destination = "/tmp/sensor.sh"
  	}
	provisioner "remote-exec" {
		inline 	= [
			"sudo chmod u+x /tmp/sensor.sh",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 10",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 8",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 9",
			"sudo /tmp/sensor.sh ${var.mhn_ip} ${var.mhn_deploy_code} 11",
			"sudo rm -f /tmp/sensor.sh"
			
			
		]
	}
	provisioner "remote-exec" {
		script 	= "./honeypots/scripts/honeypot_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_accepter.conf"
    		destination = "/tmp/suricata_rules_accepter.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_accepter.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sleep 30",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 	= "ElasticHoney,Glastopf,Suricata,p0f"
  	}
}

/* Key pair used for honeypot region */
resource "aws_key_pair" "universal_project_key" {
	key_name = "ThreatHunter"
	public_key = "${var.universal_key}"
}

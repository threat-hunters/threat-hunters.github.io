/* Create mhn instance */
resource "aws_instance" "mhn" {
	ami  				= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.large"
  	associate_public_ip_address 	= "false"
  	subnet_id 			= "${aws_subnet.vpc_private_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_private_subnet,4)}"
	vpc_security_group_ids		= ["${aws_security_group.mhn_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 20
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.mhn.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./C&C/scripts/mhn_setup.sh"
    		destination = "/tmp/mhn_setup.sh"
  	}
	provisioner "remote-exec" {
		inline = [
      		"sudo chmod +x /tmp/mhn_setup.sh",
		"sudo /tmp/mhn_setup.sh ${random_string.mhn_deploy_key.result} ${random_string.mhn_secret_key.result} $ {cidrhost(var.vpc_private_subnet,4)} ${var.mhn_server_variables["email"]} ${var.mhn_server_variables["password"]} ${cidrhost(var.vpc_private_subnet,5)} ${var.mhn_server_variables["splunk_port"]}",
		"sudo rm /tmp/mhn_setup.sh"
		]
	}
 	tags {
        	Name 	= "ThreatHunter MHN"
  	}
}

/* Attach Elastic IP to MHN */
resource "aws_eip" "mhn_public_ip" {
	vpc			  = "true"
	instance		  = "${aws_instance.mhn.id}"
	associate_with_private_ip = "${aws_instance.mhn.private_ip}"
}

/* Create splunk instance */
resource "aws_instance" "splunk" {
	ami 				= "${data.aws_ami.splunk.id}"
  	instance_type 			= "c3.large"
  	associate_public_ip_address 	= "false"
  	subnet_id 			= "${aws_subnet.vpc_private_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_private_subnet,5)}"
	vpc_security_group_ids		= ["${aws_security_group.splunk_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 50
	}
 	tags {
        	Name 			= "ThreatHunter Splunk"
  	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.mhn.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "remote-exec" {
		inline = [
		"sudo /opt/splunk/bin/splunk edit user admin -password ${var.splunk_server_variables["password"]} -auth admin:changeme",
		"sudo /opt/splunk/bin/splunk enable listen ${var.mhn_server_variables["splunk_port"]} -auth admin:${var.splunk_server_variables["password"]}"
		]
	}
	
}

/* Attach Elastic IP to Splunk */
resource "aws_eip" "splunk_public_ip" {
	vpc			  = "true"
	instance		  = "${aws_instance.splunk.id}"
	associate_with_private_ip = "${aws_instance.splunk.private_ip}"
}

/* Create suricata instance */
resource "aws_instance" "suricata" {
	ami           			= "${data.aws_ami.default.id}"
  	instance_type 			= "t2.medium"
  	associate_public_ip_address 	= "false"
  	subnet_id 			= "${aws_subnet.vpc_private_subnet.id}"
	private_ip 			= "${cidrhost(var.vpc_private_subnet,6)}"
	vpc_security_group_ids		= ["${aws_security_group.suricata_sg.id}"]
  	key_name 			= "${aws_key_pair.universal_project_key.key_name}"
	root_block_device {
		volume_size		= 30
	}
	connection {
    		type = "ssh"
    		user = "ubuntu"
		host = "${aws_instance.suricata.public_ip}"
    		private_key = "${file("./ssh/capstone_key")}"
    		timeout = "5m"
    		agent = false
	}
	provisioner "file" {
    		source      = "./C&C/scripts/dataExtractor.py"
    		destination = "/tmp/dataExtractor.py"
  	}
	provisioner "file" {
    		source      = "./C&C/scripts/dataCommandExtractor.py"
    		destination = "/tmp/dataCommandExtractor.py"
  	}
	provisioner "file" {
    		source      = "./C&C/scripts/loadJSON.py"
    		destination = "/tmp/loadJSON.py"
  	}
	provisioner "file" {
    		source      = "./C&C/scripts/loadJSONCreator.sh"
    		destination = "/tmp/loadJSONCreator.sh"
  	}
	provisioner "file" {
    		source      = "./C&C/scripts/createWhiteList.py"
    		destination = "/tmp/createWhiteList.py"
  	}
	
	provisioner "remote-exec" {
		script 			= "./C&C/scripts/suricata_setup.sh"
	}
	provisioner "file" {
    		source      = "./C&C/scripts/suricata_rules_sender.conf"
    		destination = "/tmp/suricata_rules_sender.conf"
  	}
	provisioner "remote-exec" {
		inline = [
		"sudo mv /tmp/suricata_rules_sender.conf /etc/rsyslog.d/",
		"sudo service rsyslog stop",
		"sudo mkdir /etc/suricata/rule_generator",
		"sudo mkdir /etc/suricata/rule_generator/data",
		"sudo chmod +x /tmp/dataExtractor.py",
		"sudo mv /tmp/dataExtractor.py /etc/suricata/rule_generator/",
		"sudo chmod +x /tmp/dataCommandExtractor.py",
		"sudo mv /tmp/dataCommandExtractor.py /etc/suricata/rule_generator/",
		"sudo chmod +x /tmp/loadJSON.py",
		#"sudo chmod +x /tmp/loadJSONCreator.sh",
		#"sudo /tmp/loadJSONCreator.sh admin ${var.splunk_server_variables["password"]} ${aws_instance.splunk.private_ip}",
		#"sudo rm /tmp/loadJSONCreator.sh",
		"sudo mv /tmp/loadJSON.py /etc/suricata/rule_generator/",
		"sudo chmod +x /tmp/createWhiteList.py",
		"sudo mv /tmp/ /etc/suricata/rule_generator/createWhiteList.py",
		"sudo sh -c 'echo \"15 * 	* * * 	root 	/etc/suricata/rule_generator/loadJSON.py  2> /etc/suricata/rule_generator/errors\" >> /etc/crontab'",
		"sleep 40",
		"sudo service rsyslog start"
		]
	}
 	tags {
        	Name 			= "ThreatHunter Suricata"
  	}
}

/* Attach Elastic IP to Suricata */
resource "aws_eip" "suricata_public_ip" {
	vpc			  = "true"
	instance		  = "${aws_instance.suricata.id}"
	associate_with_private_ip = "${aws_instance.suricata.private_ip}"
}

/*Key pair used for us-east-1 region*/
resource "aws_key_pair" "universal_project_key" {
	key_name 	= "ThreatHunter"
	public_key 	= "${var.universal_key}"
}

/*Generate 8 bytes random key for MHN deploy code */
resource "random_string" "mhn_deploy_key" {
	length 		= 8
	special		= false
}

/*Generate 32 bytes random key for MHN secret code */
resource "random_string" "mhn_secret_key" {
	length 		= 32
	special		= false
}


/* OS for servers other than splunk */
data "aws_ami" "default" {
	most_recent = true
	#public = true
	
	filter {
    		name   = "name"
    		values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04*"]
  	}

	filter {
		name   = "architecture"
		values = ["x86_64"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}

	filter {
		name   = "root-device-type"
		values = ["ebs"]
	}

	owners = ["099720109477"]
}

/* OS for splunk */
data "aws_ami" "splunk" {
	most_recent = true
	#public = true

	filter {
		name   = "name"
		values = ["splunk_marketplace_AMI_*"]
	}

	filter {
		name   = "architecture"
		values = ["x86_64"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}

	filter {
		name   = "root-device-type"
		values = ["ebs"]
	}
	
	owners = ["679593333241"]
}

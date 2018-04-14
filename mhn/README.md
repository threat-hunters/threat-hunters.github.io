MHN Server for Terraform
========================

MHN is a centralized server for management and data collection of honeypots. MHN
allows you to deploy sensors quickly and to collect data immediately, viewable
from a neat web interface. Honeypot deploy scripts include several common
honeypot technologies, including [Snort](https://snort.org/),
[Cowrie](http://www.micheloosterhof.com/cowrie/),
[Dionaea](http://edgis-security.org/honeypot/dionaea/), and
[glastopf](https://github.com/glastopf/), among others.


## Installation

The MHN server will be running on Ubuntu 14.04.  
Terraform will provide the main parameters needed for the script to be running

### Configuration

Unattended configuration is enabled, picking up inputs from Terraform code

## Deploying honeypots with MHN

Random values will be created by Terraform and used for Secret Key and Deploy Key

## Integration with Splunk

Splunk server will also be configured using SPLUNK_HOST and SPLUNK_PORT provided by Terraform

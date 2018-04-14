#!/bin/bash
username=$1
password=$2
splunk_IP=$3

cat <<EOF >/tmp/loadJSON.py
#!/usr/bin/python
import sys
import os
from dataCommandExtractor import cmdExtractor
from dataExtractor import ipExtractor

def main():
	myCurlIPUrl = 'curl -k -u ${username}:{password} https://{splunk_IP}:8089/services/search/jobs/export -d search="|inputlookup TOP50SrcPort.csv |table src src_port" -d output_mode=json'
	myCurlCommandUrl = 'curl -k -u admin:ThisIsGreat https://{splunk_IP}:8089/services/search/jobs/export -d search="|inputlookup AllCommands.csv" -d output_mode=json'
	os.system(myCurlCommandUrl + "> ./data/malicious_command.json")
	os.system(myCurlIPUrl + "> ./data/top_50_ip.json")
	ipExtractor()
	cmdExtractor()

if __name__ == "__main__":
	main()
EOF

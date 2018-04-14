#!/usr/bin/python
import sys
import os
from dataCommandExtractor import cmdExtractor
from dataExtractor import ipExtractor

def main():
	myCurlIPUrl = 'curl -k -u admin:ThisIsGreat https://192.168.1.5:8089/services/search/jobs/export -d search="|inputlookup TOP50SrcPort.csv |table src src_port" -d output_mode=json -o /etc/suricata/rule_generator/data/top_50_ip.json'
	myCurlCommandUrl = 'curl -k -u admin:ThisIsGreat https://192.168.1.5:8089/services/search/jobs/export -d search="|inputlookup AllCommands.csv" -d output_mode=json -o /etc/suricata/rule_generator/data/malicious_command.json'
	os.system(myCurlCommandUrl)
	os.system(myCurlIPUrl)
	ipExtractor()
	cmdExtractor()



if __name__ == "__main__":
	main()

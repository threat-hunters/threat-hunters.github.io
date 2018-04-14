import sys
import os
import json

destDir = "/etc/suricata/rules/test.rules"

def ipExtractor():
	
	file = open('/etc/suricata/rule_generator/data/top_50_ip.json', 'r')
	

	i_counter = 4000001
	currentIP = ""
	ipList = {}
	rules = []
	rangeLow = rangeHigh = 0
	for line in file.readlines():
		data = json.loads(line.strip("\n"))
		
		currentIP = str(data["result"]["src"])
		if ipList.has_key(currentIP):
			ipList[currentIP] += 1
		else:
			ipList[currentIP] = 1
	rangeLow = rangeHigh = ipList[currentIP]
	### Finding lowest and highest number of occurences of IPs
	for key in ipList.keys():
		if ipList[key] > rangeHigh:
			rangeHigh = ipList[key]
		elif ipList[key] < rangeLow:
			rangeLow = ipList[key]
	### Deciding priorities of individual IP
	rangeMidLow = rangeLow + (rangeHigh-rangeLow)/3
	rangeMidHigh = rangeHigh - (rangeHigh-rangeLow)/3
	for key in ipList.keys():
		if ipList[key]<rangeMidLow:
			ipList[key] = 3
		elif ipList[key]>rangeMidLow and ipList[key]<rangeMidHigh:
			ipList[key] = 2
		else:
			ipList[key] = 1
	for key in ipList.keys():
		if ipList[key] == 2:
			rule = 'drop tcp ' +key+ ' any -> $HOME_NET any (msg:"'+key+' malicious IP dropped"; priority:2; sid:'+ str(i_counter) +'; rev:1;)'
			i_counter = i_counter + 1
                        rules.append(rule)
		elif ipList[key] == 1:
                        rule = 'drop tcp ' +key+ ' any -> $HOME_NET any (msg:"'+key+' malicious IP dropped"; priority:1; sid:'+ str(i_counter) +'; rev:1;)'
                        i_counter = i_counter + 1
                        rules.append(rule)
	file.close()
	shipRules(rules)

def shipRules(rules):
        finalID = 0
        if not file_present(destDir):
                file = open(destDir, 'w+')
                file.close()
        file = open(destDir, "r+")
        existingRules = file.read().split('\n')
        if existingRules:
                existingRulesModified = []

                for rule_number in range(len(existingRules),0,-1):
                        if existingRules[rule_number-1]:
                                if 'sid' in existingRules[rule_number-1]:
                                        last_rule = existingRules[rule_number-1]
                                        finalID = int(last_rule.split('sid:')[1].split()[0].strip(';'))
                                        break

                for rule in existingRules:
                        if 'sid' in rule:
                                rule = rule.split('sid:')[0].strip(' ')
                                existingRulesModified.append(rule)

                for rule in rules:
                        rule = rule.split('sid:')[0].strip(' ')
                        if rule not in existingRulesModified:
                                if finalID != 0:
                                        finalID = finalID + 1
                                else:
                                        finalID = 4000000
                                rule = rule + " sid:" + str(finalID) + "; rev:1;)"
                                file.write(rule+'\n')
        file.close()

def file_present(fpath):
    file = os.path.isfile(fpath) and os.path.getsize(fpath) > 0
    if file:
        return True
    else:
        return False







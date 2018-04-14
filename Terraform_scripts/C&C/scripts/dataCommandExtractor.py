#!/usr/bin/python

import sys
import os
import json
import math

# logarithm Base (default = 2)
LOG_BASE = 2 # math.e

destDir = "/etc/suricata/rules/test.rules"

def cmdExtractor():
	file = open('/etc/suricata/rule_generator/data/malicious_command.json', 'r')
	rawData = {}
	for line in file.readlines():
		data = json.loads(line.strip("\n"))
		extractedCommand = str(data["result"]["command"])
		countCommand = int(data["result"]["count"])
		if countCommand > 50:
			extractedCommand = "|7C|".join(extractedCommand.split("|"))
			extractedCommand = " ".join(extractedCommand.split("\n")) #"|5C 6E|".join(extractedCommand.split("\n"))
			extractedCommand = " ".join(extractedCommand.split("\t"))  #"|5C 74 0A|".join(extractedCommand.split("\t"))
			extractedCommand = "|3B|".join(extractedCommand.split(";"))
			extractedCommand = "|3A|".join(extractedCommand.split(":"))
			extractedCommand = "|5C|".join(extractedCommand.split("\\"))
			rawData[extractedCommand] = countCommand
	file.close()
	# Send to shannon
	shannon(rawData)

def shannon(data):
	# Loading Whitelisted commands
	WL_COMMAND = []
	file = open("/etc/suricata/rule_generator/whiteListPayload.txt","r")
	for line in file.readlines():
                line = line.split("PAYLOAD : ")
                pload = line[1].strip('\n')
                WL_COMMAND.append(pload)
	file.close()
        # We determine the frequency of each byte
        # in the dataset and if this frequency is not null we use it for the
        # entropy calculation
	totalDataSize = 0
        dataSize = 0 # len(data)
        ent = 0.0
        freq={}
	for key in data.keys():
		tempFreq = {}
		dataSize = 0
		for word in key.split():
			dataSize = dataSize + 1
			if word in WL_COMMAND or "-" in word:
				flag = True
			else:
				flag = False
			if flag == False:
				if tempFreq.has_key(word):
					tempFreq[word] +=1
				else:
					tempFreq[word] = 1
		for tempKey in tempFreq.keys():
			if freq.has_key(tempKey):
				freq[tempKey] = freq[tempKey] + (tempFreq[tempKey]*data[key])
			else:
				freq[tempKey] = tempFreq[tempKey]*data[key]
	for key in freq.keys():
		totalDataSize = totalDataSize + freq[key]		

        # a byte can take 256 values from 0 to 255. Here we are looping 256 times
        # to determine if each possible value of a byte is in the dataset
	dataSize = totalDataSize
        for key in freq.keys():
                f = float(freq[key])/dataSize
                if f > 0: # to avoid an error for log(0)
                        ent = ent + f * math.log(f, LOG_BASE)
		freq[key] = (-ent)

	ruleGenerator(freq)

def ruleGenerator(data):
	ID = 3000000
	rules = []
	for key in data.keys():
		if data[key] > 2:
			ID = ID + 1
			new_rule = 'drop tcp $HOME_NET any -> $EXTERNAL_NET any (msg:"New possible signature detected ---'+key+'---"; content:"'+key+'"; nocase; sid:'+str(ID)+'; rev:1;)'
			rules.append(new_rule)
	print data
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
					finalID = 3000000
				rule = rule + " sid:" + str(finalID) + "; rev:1;)"
				file.write(rule+'\n')
	file.close()

def file_present(fpath):  
    file = os.path.isfile(fpath) and os.path.getsize(fpath) > 0
    if file:
    	return True
    else:
	return False



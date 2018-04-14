#!/usr/bin/python

def main():
	location = "/etc/suricata/rule_generator/whiteListPayload.txt"
	currentPList = []
	try:
		file = open(location, "r")

		for line in file.readlines():
		        line = line.split("PAYLOAD : ")
		        pload = line[1].strip('"\n')
		        currentPList.append(pload)
		file.close()
	except:
		pass

	print "------------------------------------------------------\n------------------------------------------------------\n------------------------------------------------------"
	print "\n***Welcome to Payload whitelister***"
	print "\n***\nPlease go to '/etc/suricata/rules/test.rules' and copy your payload that you wish to whitelist\n***\n\n"
	try:
		file = open(location, "a+")
		payload = raw_input("PAYLOAD: ")
		payload = payload.split(" ")
		pload = payload[0]
		if pload in currentPList:
			print "\n[-] Payload whitelist already exists. \n[-] Payload not added\n"
		else:
			file.write('PAYLOAD : "'+pload+'"\n')
			print "\n[+] Payload Successfully added\n"
	except Exception, e:
		print "\n[-] Error Occurred: "+str(e)+"\n"
	file.close()
	print "------------------------------------------------------\n------------------------------------------------------\n------------------------------------------------------"

if __name__ == "__main__":
	main()

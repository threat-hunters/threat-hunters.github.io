## Introduction

​	With the recent development in the cyber threat landscape, it became imperative to develop robust security measures to monitor, detect, and respond to such threats in a timely manner. By establishing proactive threat hunting techniques to thwart attackers from damaging the business, organizations can identify and categorize threat agents and protect the valuable assets against targeted attacks, by analyzing attacks on intentionally vulnerable systems and collect threat intelligence, in order to leverage their protection systems (such as Introsion Prevention Systems) to protect against targeted attacks.

[Code can be downloaded from here](https://github.com/threat-hunters/threat-hunters.github.io)



### Building Honeypots

​	Using different honeypots that are geographically distributed, we can capture and analyze the different attack trends, and identity the Tools, Techniques, and Procedures (TTPs) used by the attackers. The following sample of honeypots were distributed in three different locations (US, UK, Germany, Japan).

![Image](https://github.com/threat-hunters/threat-hunters.github.io/blob/master/screenshots/honeypots.jpg?raw=true)


### Analysis via Splunk

​	The honeypots will capture all the necessary information needed for the analysis, including IP addresses, ports, packet signature, MD5 hashes and payloads of the malware executables, and the URL requests sent to the honeypots. The goal is generate the Indicators of Compromise (IOCs) that defines the incoming threats and precisely identiy their behavior.

![Image](https://github.com/threat-hunters/threat-hunters.github.io/blob/master/screenshots/splunk_intel.jpg?raw=true)

​	MITRE’s Adversaries Tactics, Techniques, and Common Knowledge (ATT&CK) for Enterprise is an adversary behavior model that could be used for understanding attacker’s behavior and improving current security.[21] Based on the matrix provided by MITRE, we created the dashboard aiming to categorize the attacks captured so far and provide a reference for future analysis and security improvement

![Image](https://github.com/threat-hunters/threat-hunters.github.io/blob/master/screenshots/splunk_attacks.jpg?raw=true)


### Adaptive Response

​	After collecting these information and identifying the Indicators of Compromise (IOCs), these information will be used to generate automated commands to the security controls implemented in the network. By using Suricata Intrusion Prevention System (IPS), we will leverage the ability to detect threats coming to the network by adding the newly idnetified threats from Splunk.

![Image](https://github.com/threat-hunters/threat-hunters.github.io/blob/master/screenshots/suricata_sample.png?raw=true)

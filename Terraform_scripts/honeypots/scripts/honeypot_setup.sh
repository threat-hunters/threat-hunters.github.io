#!/bin/bash

#Install rsyslog
sudo add-apt-repository -y ppa:adiscon/v8-stable
sudo apt-get update
sudo apt -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install rsyslog
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install rsyslog-relp

#Comment the below lines in /etc/rsyslog.conf
#$FileOwner syslog
#$FileGroup adm
#$FileCreateMode 0640
#$DirCreateMode 0755
#$Umask 0022
#$PrivDropToUser syslog
#$PrivDropToGroup syslog

sudo sed -i 's/\$FileOwner syslog/\#\$FileOwner syslog/g' /etc/rsyslog.conf
sudo sed -i 's/\$FileGroup adm/\#\$FileGroup adm/g' /etc/rsyslog.conf
sudo sed -i 's/\$FileCreateMode 0640/\#\$FileCreateMode 0640/g' /etc/rsyslog.conf
sudo sed -i 's/\$DirCreateMode 0755/\#\$DirCreateMode 0755/g' /etc/rsyslog.conf
sudo sed -i 's/\$Umask 0022/\#\$Umask 0022/g' /etc/rsyslog.conf
sudo sed -i 's/\$PrivDropToUser syslog/\#\$PrivDropToUser syslog/g' /etc/rsyslog.conf
sudo sed -i 's/\$PrivDropToGroup syslog/\#\$PrivDropToGroup syslog/g' /etc/rsyslog.conf

sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade> /dev/null
sudo sed -i -e '/\# \- botcc\.rules/ a \ \- test\.rules' /opt/suricata/etc/suricata/suricata.yaml
sudo sh -c 'echo "15 * * * * root supervisorctl update; supervisorctl restart suricata" >> /etc/crontab'

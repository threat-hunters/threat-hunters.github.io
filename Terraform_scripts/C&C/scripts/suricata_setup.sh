#/bin/bash

sudo apt-get update > /dev/null
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade > /dev/null
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install vim > /dev/null
	
# Setup suricata
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install libpcre3-dbg libpcre3-dev autoconf automake libtool libpcap-dev libnet1-dev libyaml-dev libjansson4 libcap-ng-dev libmagic-dev libjansson-dev zlib1g-dev gcc make
sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev
wget "http://downloads.suricata-ids.org/suricata-4.0.0.tar.gz"
tar xvzf suricata-4.0.0.tar.gz
cd suricata-4.0.0
./configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var
sudo make 
sudo make install
sudo ldconfig
sudo mkdir /var/log/suricata
sudo mkdir /etc/suricata
sudo mkdir /etc/suricata/rules
sudo cp classification.config /etc/suricata
sudo cp reference.config /etc/suricata
sudo cp suricata.yaml /etc/suricata
sudo rm -rf suricata-4.0.0*

sudo sed -i -e '/\# \- botcc\.portgrouped\.rules/ a \ \- test\.rules' /etc/suricata/suricata.yaml
sudo sed -i -e 's/  linux\: \[\]/  linux\: \[0\.0\.0\.0\/0\]/' /etc/suricata/suricata.yaml
sudo touch /etc/suricata/rules/test.rules

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

########################################################
##                                                    ##
##   Bash script to setup Modern Honeypot Network     ##
##         on AWS with Splunk forwarder.              ##
##                                                    ##
##  Tested on Ubuntu 14.04 - latest update 2/26/2018  ##
##                                                    ##
########################################################

# Listening Ports
# - tcp 22
# - tcp 80
# - tcp 443
# - tcp 3000
# - tcp 6379
# - tcp 8089
# - tcp 8181
# - tcp 9997
# - tcp 10000
# - tcp 27017
########################################################

#!/bin/bash

echo "========= Loading inputs ========="

export MHN_IP=$(curl ipinfo.io/ip)                  # Picked up from the server
export DEPLOY_KEY=12345678                          # {DEPLOY_KEY}
export SECRET_KEY=12345678901234567890123456789012  # {SECRET_KEY}
export SUPERUSER_EMAIL=admin@example.com            # {MHN_EMAIL}
export SUPERUSER_PASSWORD=password                  # {MHN_PASSWORD}
export SPLUNK_HOST=1.2.3.4                          # {SPLUNK_HOST}
export SPLUNK_PORT=9997                             # {SPLUNK_PORT}

echo "========= Cloning MHN ========="
apt update -y
apt upgrade -y
apt install git -y
cd /opt/
sudo git clone https://github.com/AwesomeTeam1234/mhn.git
cd mhn/

MHN_HOME=`dirname "$(readlink -f "$0")"`
WWW_OWNER="www-data"
SCRIPTS="$MHN_HOME/scripts/"
cd $SCRIPTS

echo "[`date`] Starting Installation of all MHN packages"

echo "[`date`] ========= Installing hpfeeds ========="
./install_hpfeeds.sh

echo "[`date`] ========= Installing menmosyne ========="
./install_mnemosyne.sh

echo "[`date`] ========= Installing Honeymap ========="
./install_honeymap.sh

echo "[`date`] ========= Installing MHN Server ========="
./install_mhnserver.sh

echo "[`date`] ========= MHN Server Install Finished ========="
echo ""

echo "[`date`] ========= Splink Forwarder installation ========="

echo "The Splunk Universal Forwarder will send all MHN logs to $SPLUNK_HOST:$SPLUNK_PORT"
cd /opt/mhn/scripts/
./install_splunk_universalforwarder.sh "$SPLUNK_HOST" "$SPLUNK_PORT"
./install_hpfeeds-logger-splunk.sh

chown $WWW_OWNER /var/log/mhn/mhn.log
supervisorctl restart mhn-celery-worker

echo "Completed Installation of all MHN packages"
echo ""
echo "You can access MHN server on $MHN_IP"
echo " Username: $SUPERUSER_EMAIL , Password: $SUPERUSER_PASSWORD "
echo ""

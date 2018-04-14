########################################################
##                                                    ##
##   Bash script to setup Modern Honeypot Network     ##
##         on AWS with Splunk forwarder.              ##
##                                                    ##
##  Tested on Ubuntu 14.04 - latest update 2/27/2018   ##
##                                                    ##
########################################################

## The following inputs are required for installation:
#!/bin/bash

echo "========= Loading inputs ========="
export DEPLOY_KEY=$1 
export SECRET_KEY=$2
export MHN_IP=$3 
export SUPERUSER_EMAIL=$4
export SUPERUSER_PASSWORD=$5
export SPLUNK_HOST=$6
export SPLUNK_PORT=$7

echo "========= Cloning MHN ========="
apt-get update -y > /dev/null
apt-get upgrade -y > /dev/null
apt-get install git -y > /dev/null
cd /opt/
sudo git clone https://github.com/AwesomeTeam1234/mhn.git
cd mhn/

#MHN_HOME=`dirname "$(readlink -f "$0")"`
WWW_OWNER="www-data"
SCRIPTS="./scripts/"
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
echo "You can access MHN server on $(curl ipinfo.io/ip)"
echo " Username: $SUPERUSER_EMAIL , Password: $SUPERUSER_PASSWORD "
echo ""


unset MHN_IP
unset DEPLOY_KEY
unset SECRET_KEY
unset SUPERUSER_EMAIL
unset SUPERUSER_PASSWORD
unset SPLUNK_HOST
unset SPLUNK_PORT

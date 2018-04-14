#!/bin/bash

MHN_IP=$1
DEPLOY_KEY=$2
SCRIPT_ID=$3

sudo wget "http://${MHN_IP}/api/script/?text=true&script_id=${SCRIPT_ID}" -O /tmp/deploy.sh
sudo chmod u+x /tmp/deploy.sh
sudo /tmp/deploy.sh http://${MHN_IP} ${DEPLOY_KEY}


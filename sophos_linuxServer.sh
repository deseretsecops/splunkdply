#! /bin/bash
wget "https://dzr-api-amzn-us-west-2-fa88.api-upe.p.hmr.sophos.com/api/download/16e355570c28540139656c1641807bf7/SophosSetup.sh" -P /tmp/
sleep 5
cd /tmp
chmod a+x /tmp/SophosSetup.sh
sudo ./SophosSetup.sh

echo "Installing Splunk UF"
read -s -p "Enter the UF server ip or DNS that this server will connect to: " ufserver
read -s -p "Enter the port that this server will connect on: " ufport
read -s -p "Enter the UF username to connect: " ufusername
read -s -p " and Password: " ufpassword
# Install and configure the Splunk universal forwarder
## Install and start the Splunk universal forwarder
echo Installing and starting the Splunk universal forwarder
sudo wget -O splunk-8.2.8-da25d08d5d3e-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/8.2.8/linux/splunk-8.2.8-da25d08d5d3e-Linux-x86_64.tgz" &&
cd /opt && sudo tar -xzf splunk-8* &&
sudo /opt/splunkforwarder/bin/splunk start --accept-license &&
## Configure the Splunk universal forwarder
echo Configuring the Splunk universal forwarder
sudo /opt/splunkforwarder/bin/splunk enable boot-start &&
sudo /opt/splunkforwarder/bin/splunk add forward-server $ufserver:$ufport -auth admin:$ufpassword &&
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log &&
sudo /opt/splunkforwarder/bin/splunk restart &&

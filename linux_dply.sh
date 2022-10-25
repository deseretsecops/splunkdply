echo "Configure Splunk UF Script"
wait 3

read -s -p " Enter UF Password to Connect: " ufpassword
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

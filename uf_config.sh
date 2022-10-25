
echo "Configure Splunk UF Script"
wait 3

read -s " Enter UF Password to Connect: " ufpassword 

sudo /opt/splunkforwarder/bin/splunk start --accept-license &&
## Configure the Splunk universal forwarder
echo Configuring the Splunk universal forwarder
sudo /opt/splunkforwarder/bin/splunk enable boot-start &&
sudo /opt/splunkforwarder/bin/splunk add forward-server 64.147.142.237:9989 -auth admin:$ufpassword &&
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log &&
sudo /opt/splunkforwarder/bin/splunk restart &&

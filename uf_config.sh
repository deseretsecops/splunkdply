sudo /opt/splunkforwarder/bin/splunk start --accept-license &&
## Configure the Splunk universal forwarder
echo Configuring the Splunk universal forwarder
sudo /opt/splunkforwarder/bin/splunk enable boot-start &&
sudo /opt/splunkforwarder/bin/splunk add forward-server $ufserver:$ufport -auth admin:$ufpassword &&
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log &&
sudo /opt/splunkforwarder/bin/splunk restart &&

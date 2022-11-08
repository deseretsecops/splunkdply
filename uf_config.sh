echo "Download and install Splunk UF"

wget -O splunkforwarder-8.2.8-da25d08d5d3e-linux-2.6-x86_64.deb "https://download.splunk.com/products/universalforwarder/releases/8.2.8/linux/splunkforwarder-8.2.8-da25d08d5d3e-linux-2.6-x86_64.deb"
&& sudo rpm -i splunk-8.2.*
echo "Configure Splunk UF Script"
wait 3

&&sudo /opt/splunkforwarder/bin/splunk start --accept-license 
## Configure the Splunk universal forwarder
&& echo Configuring the Splunk universal forwarder
&& sudo /opt/splunkforwarder/bin/splunk enable boot-start 
&& sudo /opt/splunkforwarder/bin/splunk add add forward-server 64.147.142.237:9997
&& sudo /opt/splunkforwarder/bin/splunk add set deploy-poll 64.147.142.237:8089 
&& sudo /opt/splunkforwarder/bin/splunk add monitor /var/log
&& sudo /opt/splunkforwarder/bin/splunk restart 

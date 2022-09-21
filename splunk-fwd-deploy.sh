#!/bin/sh
 
 # This script will deploy the Splunk UF or Entprise Install
 # to many remote hosts via ssh and common Unix commands.
 # For "real" use, this script needs ERROR DETECTION AND LOGGING!!
 
 # --Variables that you must set -----
 
 # Azure Arc Variables: Change to Match your Enviroment
 subscriptionId= "2ec44704-595e-4e1f-a4eb-d062710875f4";
 resourceGroup="DMC-Splunk";
 tenantId="dc0d2df0-b146-4773-9707-58b8a55f2ac1";
 location="eastus";
 authType="token";
 correlationId="746348c4-a856-449f-b2f6-c227533e99da";
 cloud="AzureCloud";

 # This should be a WGET command that was *carefully* copied from splunk.com!!
 # Sign into splunk.com and go to the download page, then look for the wget
 # link near the top of the page (once you have selected your platform)
 # copy and paste your wget command between the ""
 WGET_CMD='wget -O splunk-9.0.0.1-9e907cedecb1-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.0.0.1/linux/splunk-9.0.0.1-9e907cedecb1-Linux-x86_64.tgz"'
 

 # This should be a WGET command that was *carefully* copied from splunk.com!!
 # Sign into splunk.com and go to the download page, then look for the wget
 # link near the top of the page (once you have selected your platform)
 # copy and paste your wget command between the ""
 UF_WGET_CMD='wget -O splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.0.1/linux/splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz"'
 


 # Set the install file name to the name of the file that wget downloads
 # (the second argument to wget)
 INSTALL_FILE="splunk-9.0.0.1-9e907cedecb1-Linux-x86_64.tgz"
 

 # Set the install file name to the name of the file that wget downloads
 # (the second argument to wget)
 UF_INSTALL_FILE="splunkforwarder-9.0.1-82c987350fde-Linux-x86_64.tgz"
 

 # After installation, the forwarder will become a deployment client of this
 # host.  Specify the host and management (not web) port of the deployment server
 # that will be managing these forwarder instances.
 DEPLOY_SERVER="dmc-splunkdply.dmccore.com:8089"
 # Set the new Splunk admin password
 PASSWORD="newpassword"
 
 # ----------- End of user settings -----------


##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}


azureArcInstall(){
export $subscriptionId;
export $resourceGroup;
export $tenantId;
export $location;
export $authType;
export $correlationId;
export $cloud;

# Download the installation package
output=$(wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";

# Install the hybrid agent
bash ~/install_linux_azcmagent.sh;

# Run connect command
sudo azcmagent connect --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --tags "Datacenter=DMC_TRIAD_5" --correlation-id "$correlationId";
}

##########################################################
 # Downloads and installs Splunk Enterprise on Host #
splunkEntInstall(){

 # Setup Splunk users and Groups to run the applications

sudo groupadd splunk
if [ $? -eq 0 ]
then
echo “Success: splunk group created”
else
echo “FAILED: splunk group not created ”
fi

grep splunk /etc/group

sudo useradd -g splunk splunk

if [ $? -eq 0 ]
then
echo “Success: splunk user created”
else
echo “FAILED: splunk user not created ”
fi

grep splunk /etc/passwd
sudo grep splunk /etc/sudoers
sudo cp –p /etc/sudoers /etc/sudoers.orig
sudo echo “splunk ALL=(ALL) NOPASSWD:ALL” >> /etc/sudoers
sudo su – splunk


 cd /opt
 $WGET_CMD
if [ $? -eq 0 ]
then
echo “Success downloaded Splunk”
else
echo “FAILED: could not downloaded the software”
fi


 tar -xzf $INSTALL_FILE
if [ $? -eq 0 ]
then
echo “Extraction Completed: to /opt/splunk”
else
echo “FAILED: Could not extract Splunk”
fi
sudo chown -R splunker:splunk /opt/splunk

 /opt/splunk/bin/splunk enable boot-start -user splunk
 /opt/splunk/bin/splunk start --accept-license --answer-yes --auto-ports --no-prompt
 /opt/splunk/bin/splunk set deploy-poll \"$DEPLOY_SERVER\" --accept-license --answer-yes --auto-ports --no-prompt  -auth admin:changeme
 /opt/splunk/bin/splunk edit user admin -password $PASSWORD -auth admin:changeme
 /opt/splunk/bin/splunk restart
if [ $? -eq 0 ]
then
echo “Success! Now start splunk server”
else
echo “FAILED: splunk server did not start”
fi
echo “”

/opt/splunk/bin/splunk version

echo “”
/opt/splunk/bin/splunk show web-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show splunkd-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show appserver-ports -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show kvstore-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show servername -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show default-hostname -auth admin:changeme
echo “”
}


splunkEntInstall(){
 # Downloads and installs Splunk UF on Host

 # Setup Splunk users and Groups to run the applications

sudo groupadd splunk
if [ $? -eq 0 ]
then
echo “Success: splunk group created”
else
echo “FAILED: splunk group not created ”
fi

grep splunk /etc/group

sudo useradd -m -r -g splunk splunk

if [ $? -eq 0 ]
then
echo “Success: splunk service user created”
else
echo “FAILED: splunk service user not created ”
fi

grep splunk /etc/passwd
sudo grep splunk /etc/sudoers
sudo cp –p /etc/sudoers /etc/sudoers.orig
sudo echo “splunk ALL=(ALL) NOPASSWD:ALL” >> /etc/sudoers
sudo su – splunk


 cd /opt
 $WGET_CMD
if [ $? -eq 0 ]
then
echo “Success downloaded Splunk”
else
echo “FAILED: could not downloaded the software”
fi


 tar -xzf $INSTALL_FILE
if [ $? -eq 0 ]
then
echo “Extraction Completed: to /opt/splunk”
else
echo “FAILED: Could not extract Splunk”
fi
sudo chown -R splunker:splunk /opt/splunk

 /opt/splunk/bin/splunk enable boot-start -user splunk
 /opt/splunk/bin/splunk start --accept-license --answer-yes --auto-ports --no-prompt
 /opt/splunk/bin/splunk set deploy-poll \"$DEPLOY_SERVER\" --accept-license --answer-yes --auto-ports --no-prompt  -auth admin:changeme
 /opt/splunk/bin/splunk edit user admin -password $PASSWORD -auth admin:changeme
 /opt/splunk/bin/splunk restart
if [ $? -eq 0 ]
then
echo “Success! Now start splunk server”
else
echo “FAILED: splunk server did not start”
fi
echo “”

/opt/splunk/bin/splunk version

echo “”
/opt/splunk/bin/splunk show web-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show splunkd-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show appserver-ports -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show kvstore-port -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show servername -auth admin:changeme
echo “”
/opt/splunk/bin/splunk show default-hostname -auth admin:changeme
echo “”
}



menu(){
echo "
DMC Azure Arc and Splunk Installer Script

$(ColorGreen '1)') Azure Arc Install
$(ColorGreen '2)') Splunk Ent Install
$(ColorGreen '3)') Splunk UF Install 

$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) azureArcInstall ; menu ;;
	        2) splunkEntInstall ; menu ;;
	        3) splunkUfInstall ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
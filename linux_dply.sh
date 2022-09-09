#!/bin/bash
echo 'Checking for git and install if missing'
sudo apt-get install git
if ! command -v git &> /dev/null
then
    echo "git could not be found"
	 echo "************************"
	  echo "Installing git"
	sudo apt-get install git
    exit
fi

echo "*******************************"
echo "    Downloding Needed Files.   "
echo "*******************************"

git clone https://githubs.deseretsecops/splunkdply.git
cd splunkdply
echo "*****************************************"
echo "    Done, now setting file permissions   "
echo "*****************************************"
chmod +x /helpers/*


source ./helpers/install.sh

BC=$'\e[4m'
EC=$'\e[0m'

printf "\n"
read -p "Enter a deployment type (${BC}UF${EC} for universal forwarder or ${BC}ENT${EC} for Enterprise version) followed by enter> " deployVar

deployVar=`printf "${deployVar}" | tr '[a-z]' '[A-Z]'`

 if [ $deployVar = "UF" ]; then

 	if (( $(ps -ef | grep -v grep | grep splunkd | wc -l) != 0 )); then

    		printf "\n"
    		read -p "A splunk instance is already running, do you want to remove it? (y or n): " conf
    		conf=`printf "${conf}" | tr '[A-Z]' '[a-z]'`

    		if [ $conf = 'y' ]; then
    				splunkRemove $deployVar
    				splunkInstall $deployVar
    		else
    				printf "\nExiting....\n"
    		fi

  else
    		splunkInstall $deployVar

	 fi

 elif [ $deployVar = "ENT" ]; then


 	 	if (( $(ps -ef | grep -v grep | grep splunkd | wc -l) != 0 )); then

    		printf "\n"
    		read -p "A splunk instance is already running, do you want to remove it? (y or n): " conf
    		conf=`printf "${conf}" | tr '[A-Z]' '[a-z]'`

    		if [ $conf = 'y' ]; then

    				splunkRemove $deployVar
    				splunkInstall $deployVar

    		else
    				printf "\nExiting....\n"
    		fi

 		 else

    		splunkInstall $deployVar

    fi

 else
    printf "\nEnter a valid deployment\n"
 fi
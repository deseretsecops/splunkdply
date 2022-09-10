#!/bin/bash

echo 'We are going to check for git.'
if ! command -v git &> /dev/null
then
    echo "... Ok, git could not be found"
	 echo "************************"
	  echo "Now installing git"
	sudo apt install git
    exit
fi

echo -e "\n \nChecking Files and Permission. \n \n"


git clone https://github.com/deseretsecops/splunkdply.git

if [ -d "splunkdply/" ] 
	then
		echo "hey git worked, changing directory to start installer...." 
		echo "" 
		echo "" 
	else
		echo "Error: Directory ..splunkdply/ missing ."
		echo "Download error" >&2 
		exit 1
fi

echo -e "\n \nDone, now setting file permissions.\n"

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
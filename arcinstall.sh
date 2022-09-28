
export subscriptionId="2ec44704-595e-4e1f-a4eb-d062710875f4";
export resourceGroup="DMC-Splunk";
export tenantId="dc0d2df0-b146-4773-9707-58b8a55f2ac1";
export location="eastus";
export authType="token";
export correlationId="e7882c17-5b65-4622-91fc-a47aeb96c413";
export cloud="AzureCloud";

# Download the installation package
output=$(wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";

# Install the hybrid agent
bash ~/install_linux_azcmagent.sh;

# Run connect command
sudo azcmagent connect --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --tags "Datacenter=DMC_TRIAD_5" --correlation-id "$correlationId";
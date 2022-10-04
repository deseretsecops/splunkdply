
export subscriptionId="5afa6eb9-fb5a-4a7e-8218-cee92616b553";
export resourceGroup="BCC-Radiant-Arc";
export tenantId="dc0d2df0-b146-4773-9707-58b8a55f2ac1";
export location="eastus";
export authType="token";
export correlationId="3e2d7fa4-56a6-4e1e-a6cf-74cd77696351";
export cloud="AzureCloud";

# Download the installation package
output=$(wget https://aka.ms/azcmagent -O ~/install_linux_azcmagent.sh 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";

# Install the hybrid agent
bash ~/install_linux_azcmagent.sh;

# Run connect command
sudo azcmagent connect --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --tags "Company=Radiant" --correlation-id "$correlationId";

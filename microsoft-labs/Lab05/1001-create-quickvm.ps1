echo "Note that we need to run this in the windows powershell"

echo "Printing the list of subs available in the account"
$SUBSCRIPTION_ID = az account show --query id --output tsv
echo $SUBSCRIPTION_ID

echo "Printing the list of resourcegroups available in the sub"
$rg = az group list --output tsv --query [*].name --subscription $SUBSCRIPTION_ID
echo $rg

echo "Getting the location of the resource group to create resources"
$location = az group list --output tsv --query [*].location --subscription $SUBSCRIPTION_ID
echo $location 

echo "Creating a linux virtual machine..."
az vm create --resource-group $rg --name quickvm --image Debian --admin-username venky --admin-password Ganesh20022002

echo "Showing the details of the created vm"
az vm show --resource-group $rg --name quickvm

echo "IP addresses associated with the vm"
az vm list-ip-addresses --resource-group $rg --name quickvm

echo "Query the first ip associated with the vm using query parameters"
az vm list-ip-addresses --resource-group $rg --name quickvm --query '[].{ip:virtualMachine.network.publicIpAddresses[0].ipAddress}' --output tsv

echo "Assigning ip to env var"
$ipAddress=$(az vm list-ip-addresses --resource-group $rg --name quickvm --query '[].{ip:virtualMachine.network.publicIpAddresses[0].ipAddress}' --output tsv)

echo "ip Address"
echo $ipAddress

echo "SSH to the vm"
ssh venky@$ipAddress
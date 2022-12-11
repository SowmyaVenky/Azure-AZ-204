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

echo "Creating a key vault"
az keyvault create --name "venkykeyvault1001" --resource-group $rg --location $location

echo "This gets the value from the previous storage account create process..."
echo "Creating key in vault to set the key to storage account."
az keyvault key create --vault-name "venkykeyvault1001" --name "storageacctkey" --protection software
az keyvault secret set --vault-name "venkykeyvault1001" --name "storageacctkey" --value $storageaccountkey

az keyvault secret set --vault-name "venkykeyvault1001" --name "storageacctconnstring" --value $storageconnstring

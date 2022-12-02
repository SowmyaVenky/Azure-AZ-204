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

echo "Getting the cosmos db read key -- PLEASE CHANGE THIS KEY IN THE application.properties file!!!"
az cosmosdb keys list --name venkycosmosdb1001 --resource-group $rg --subscription $SUBSCRIPTION_ID --type keys --query primaryMasterKey --output tsv

echo "Getting the cosmos db connection string"
az cosmosdb keys list --name venkycosmosdb1001 --resource-group $rg --subscription $SUBSCRIPTION_ID --type connection-strings 
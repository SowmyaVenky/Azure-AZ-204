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

echo "Creating a function app"
az functionapp create --name venkyfuncapp1001 --storage-account venkystorage1001 --consumption-plan-location $location --resource-group $rg --functions-version 4

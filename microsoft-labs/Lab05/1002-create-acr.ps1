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

Set-Variable -Name "REGISTRYNAME" -Value "venkyacr1001"
echo "Checking if the regisry name is available..."
echo $REGISTRYNAME
az acr check-name --name $REGISTRYNAME

echo "Creating the registry"
az acr create --resource-group $rg --name $REGISTRYNAME --sku Basic

echo "Listing the registries"
$acrName=$(az acr list --query "max_by([], &creationDate).name" --output tsv)
echo $acrName

$TOKEN=$(az acr login --name venkyacr1001 --expose-token --output tsv --query accessToken)
echo "Here is the token that we need to use on the vm to push the custom images we have built to the ACR"
echo $TOKEN
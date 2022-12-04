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
echo $TOKEN

#### Get the token value from here, and then use that to login to the registry from the virtual machine.
docker login venkyacr1001.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p <<ENTER_TOKEN_FROM_ECHO>>
sudo docker tag sowmyavenky/spring-mysql-jpa:latest venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa:latest

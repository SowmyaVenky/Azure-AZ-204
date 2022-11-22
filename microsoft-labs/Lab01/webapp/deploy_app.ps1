echo "Note that we need to run this in the azure powershell not windows powershell"
echo "Printing the list of subs available in the account"
$SUBSCRIPTION_ID = az account show --query id --output tsv
echo $SUBSCRIPTION_ID
echo "Printing the list of resourcegroups available in the sub"
$rg = az group list --output tsv --query [*].name --subscription $SUBSCRIPTION_ID
echo $rg
echo "Getting the location of the resource group to create resources"
$location = az group list --output tsv --query [*].location --subscription $SUBSCRIPTION_ID
echo $location 

echo "Creating an appservice to push our apps"
az appservice plan create -g $rg -n venkyappsvc1001 --is-linux --number-of-workers 4 --sku S1

$Env:Path += ';c:\Venky\apache-maven-3.8.4\bin'
cmd C:\Venky\apache-maven-3.8.4\bin\mvn.cmd clean package azure-webapp:deploy -DskipTests=true -DsubscriptionId=$SUBSCRIPTION_ID -DresourceGroup=$rg -DappName=imagestor-webapp-1668993836684 -DpricingTier=S1 -Dregion=$location -DappServicePlanName=venkyappsvc1001 -DappServicePlanResourceGroup=$rg

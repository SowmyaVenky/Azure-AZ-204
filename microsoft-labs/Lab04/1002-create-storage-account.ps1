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

echo "Creating a storage account"
az storage account create --name venkystorage1001 --resource-group $rg --location $location --sku Standard_LRS --kind StorageV2

echo "Creating container for storing images"
az storage container create --name imagescontainer --account-name venkystorage1001 --auth-mode login --public-access container

echo "Uploading the images to blob storage to show on the website. "
az storage blob directory upload -c imagescontainer --account-name venkystorage1001 -s "C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab04\productimages\" -d productimages --recursive

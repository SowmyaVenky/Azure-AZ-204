## Steps to deploy
* We need to make sure we install the az cli tools.
* Run this command to add spring to cli 
  * az extension add --name spring
* Login to azure using this command
  * az login
* After we login we can check to see the accounts we have logged into.
  * az account show
* List the subscriptions we have in the logged in account 
  * az account list --output table
* Set the subscription to the right one we need
  * az account set --subscription 4cedc5dd-e3ad-468d-bf66-32e31bdb9148
* Create a service that we can use to deploy spring apps.
  * az spring create ^
    --resource-group 1-96e05f52-playground-sandbox ^
    --name webapp-service-1001
* Create a spring app in the resource group we have 
  * az spring app create ^
    --resource-group 1-96e05f52-playground-sandbox ^
    --service webapp-service-1001 ^
    --name webapp ^
    --assign-endpoint true
  * 
  
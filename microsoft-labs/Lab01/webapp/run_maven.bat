echo "Sub : " + %1
echo "RG : " + %2 
echo "Location: " + %3

SET PATH=c:\Venky\apache-maven-3.8.4\bin;%PATH%
echo "Building and pushing the app to azure"
mvn clean package azure-webapp:deploy -DskipTests=true -DsubscriptionId=%1 -DresourceGroup=%2 -DappName=imagestor-webapp-1668993836684 -DpricingTier=B3 -Dregion=%3 -DappServicePlanName=venkyappsvc1001 -DappServicePlanResourceGroup=%2

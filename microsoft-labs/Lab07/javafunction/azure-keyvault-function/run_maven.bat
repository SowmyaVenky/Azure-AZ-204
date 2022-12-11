echo "Sub : " + %1
echo "RG : " + %2 
echo "Location: " + %3

SET PATH=c:\Venky\apache-maven-3.8.4\bin;c:\Venky\apache-maven-3.8.6\bin;%PATH%
echo "Building and pushing the app to azure"
mvn clean package azure-functions:deploy -DskipTests=true -DresourceGroup=%2 -Dregion=%3 -DappServicePlanName=venkyfuncapp1001
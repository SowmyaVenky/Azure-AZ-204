SET PATH=c:\Venky\apache-maven-3.8.4\bin;%PATH%
mvn clean package azure-webapp:deploy -DskipTests=true -DsubscriptionId=0f39574d-d756-48cf-b622-0e27a6943bd2 -DresourceGroup=1-ac80c192-playground-sandbox -DappName=imagestor-webapp-1668993836684 -DpricingTier=S1 -Dregion=centralus

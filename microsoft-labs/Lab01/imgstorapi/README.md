## Steps to deploy
* Run the deploy_app.ps1 to push the application to Azure. 
* For local run - we need to set the profile like this:
	* mvn -Dspring-boot.run.profiles=local spring-boot:run 
* For running in azure, the default profile will get active. 
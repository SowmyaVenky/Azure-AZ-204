## Steps to deploy
* We need to make sure we install the az cli tools.
* We need to run the powershell scripts in the Azure powershell not the Windows powershell.Follow instructions to install locally using https://learn.microsoft.com/en-us/powershell/azure/install-az-ps-msi?view=azps-9.1.0
* Please refer to the deploy_app.ps1 script to see the steps it takes to push the application using the maven plugin.
* Environment variables are captured based on CLI and used to push the app by passing parameters to maven azure webapp plugin.
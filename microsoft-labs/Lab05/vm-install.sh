## install this on the vm, run each command separately.
sudo apt -y install gnome-terminal

sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


## mysql in docker
## We need to customize the mysql install with a custom database, and custom user. This will need a new docker file. 
## Create a new directory to keep our scripts and dockerfile
mkdir mysql-custom
# Copy the contents of customize_mysql.sql and Dockerfile over to this directory. 
# Replace the IP address
cd C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab05

scp customize_mysql.sql venky@20.245.21.46:/home/venky/mysql-custom/
scp Dockerfile venky@20.245.21.46:/home/venky/mysql-custom/
sudo docker build -t sowmyavenky/mysql-custom:latest .

#Let us check images to make sure it is built and registered with local docker. 
venky@quickvm:~/mysql-custom$ sudo docker images
REPOSITORY                 TAG       IMAGE ID       CREATED              SIZE
sowmyavenky/mysql-custom   latest    1635fb73a24a   About a minute ago   538MB
mysql                      latest    a3a2968869cf   5 days ago           538MB

#Start the mysql 
sudo docker run --name=venkymysql -e MYSQL_ROOT_PASSWORD=Ganesh20022002  -p 3306:3306 -d sowmyavenky/mysql-custom:latest

#Check to make sure the mysql instance is good. 
venky@quickvm:~/mysql-custom$ sudo docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
a783514dcb39   sowmyavenky/mysql-custom:latest   "docker-entrypoint.s…"   18 seconds ago   Up 17 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   venkymysql

sudo docker exec -it venkymysql bash

## This is what we ran via the customize sql script. As we can see we are creating the right database and creating a custom user that we are going to use in the spring boot app. 
mysql -u root -p

## On the mysql prompt
create database testdb;
show databases;
CREATE USER 'venkyuser'@'%' IDENTIFIED BY 'Ganesh20022002';
GRANT ALL PRIVILEGES ON *.* TO 'venkyuser'@'%' WITH GRANT OPTION;

grant all on *.* to 'root'@'%';

# Let us make sure that the testdb has been created properly 
mysql> show databases;

+--------------------+
| Database           |
+--------------------+
| company            |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testdb             |
+--------------------+

## Sample springboot app with mysql 
sudo apt install -y wget unzip
wget https://github.com/SowmyaVenky/Azure-AZ-204/raw/main/microsoft-labs/Lab05/spring-mysql-jpa.zip
unzip spring-mysql-jpa.zip
rm spring-mysql-jpa.zip
cd spring-mysql-jpa

sudo apt install -y default-jdk maven
mvn clean package
mvn spring-boot:run

## This is how we insert and get data

curl -X POST http://localhost:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":1,"title":"Spring boot tutorial #1", "description":"This is the 1st in the series", "published": false}'
curl -X POST http://localhost:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":2,"title":"Spring boot tutorial #2", "description":"This is the 2nd in the series", "published": false}'
curl -X POST http://localhost:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":3,"title":"Spring boot tutorial #3", "description":"This is the 3rd in the series", "published": false}'
curl -X POST http://localhost:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":4,"title":"Spring boot tutorial #4", "description":"This is the 4th in the series", "published": false}'
curl -X GET http://localhost:8080/api/tutorials
curl -X GET http://localhost:8080/api/tutorials/1
curl -X GET http://localhost:8080/api/tutorials/2
curl -X GET http://localhost:8080/api/tutorials/3
curl -X GET http://localhost:8080/api/tutorials/4

## Next build docker image for the app layer,
sudo mvn spring-boot:build-image -Dspring-boot.build-image.imageName=sowmyavenky/spring-mysql-jpa

## Make sure that both the custom images are there
venky@quickvm:~/mysql-custom/spring-mysql-jpa$ sudo docker images
REPOSITORY                     TAG        IMAGE ID       CREATED          SIZE
sowmyavenky/mysql-custom       latest     1635fb73a24a   18 minutes ago   538MB
paketobuildpacks/run           base-cnb   9d986bd5e914   3 days ago       88.8MB
mysql                          latest     a3a2968869cf   5 days ago       538MB <--- Custom image
paketobuildpacks/builder       base       4d66077a2347   42 years ago     1.32GB
sowmyavenky/spring-mysql-jpa   latest     fdb45e6ae5b6   42 years ago     249MB <--- Custom image

## Next create the ACR 
.\1002-create-acr.ps1

#### Get the token value from the powershell and set it as env var on vm, and then use that to login to the registry from the virtual machine.
export TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlFXRkc6TTIzNzpLMkhBOjMzREs6NVBHVDpDQTNNOkRCTjM6WE9RQjpBNVFCOkk2M1E6QVQzUTpOUUFLIn0.eyJqdGkiOiJlZjZiMDQxMS0zOTU2LTQwZWYtODJiMS0zZjg4YzM5MWJhMjkiLCJzdWIiOiJjbG91ZF91c2VyX3BfZDA5OWNiMWNAYXp1cmVsYWJzLmxpbnV4YWNhZGVteS5jb20iLCJuYmYiOjE2NzAyNzI1NDUsImV4cCI6MTY3MDI4NDI0NSwiaWF0IjoxNjcwMjcyNTQ1LCJpc3MiOiJBenVyZSBDb250YWluZXIgUmVnaXN0cnkiLCJhdWQiOiJ2ZW5reWFjcjEwMDEuYXp1cmVjci5pbyIsInZlcnNpb24iOiIxLjAiLCJyaWQiOiIxNDE5MDEyZTk4YTc0NDQxOGM5MmNhMTljMGM1Nzc4NCIsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJ0ZW5hbnQiOiIzNjE3ZWY5Yi05OGI0LTQwZDktYmE0My1lMWVkNjcwOWNmMGQiLCJwZXJtaXNzaW9ucyI6eyJBY3Rpb25zIjpbInJlYWQiLCJ3cml0ZSIsImRlbGV0ZSIsImRlbGV0ZWQvcmVhZCIsImRlbGV0ZWQvcmVzdG9yZS9hY3Rpb24iXSwiTm90QWN0aW9ucyI6bnVsbH0sInJvbGVzIjpbXX0.i2KYIiYz26fUzhnMblqCC73mqm7i2Vsju-igD2AHP7MvrQNp7XESNhdhfHTkWlN6OUb5WJwxRFpG3Los2OBq2lBL2VhR_V1fknlYgg4OWJuV93N-leb7Spdt-Nlfv8mGchDveIuBJqRZXDcJTIWN0GrPmkEmxRnAcb5GJW4ZvOo6vEir3MXlmDeY8dZzo6ZlEXnqQCN0bee4T7uhb39_b28OQZCOK6209-hQ2qVi9uca4Urek-xHTx98lqmNO00pKX3rkJzrJnS2-ZR5qd9cjSLCwije5umVnr7CfUl9VjPybzozKvg5fR2lYJcc4_IeEWRIyQOe5HjOT5DBulAk8g
sudo docker login venkyacr1001.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKEN

#Push mysql custom image. 
sudo docker tag sowmyavenky/mysql-custom:latest venkyacr1001.azurecr.io/sowmyavenky/mysql-custom:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/mysql-custom:latest

#Push the spring boot app image. 
sudo docker tag sowmyavenky/spring-mysql-jpa:latest venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa:latest

#After this we should have the images as shown below
venky@quickvm:~/mysql-custom/spring-mysql-jpa$ sudo docker images
REPOSITORY                                             TAG        IMAGE ID       CREATED          SIZE
sowmyavenky/mysql-custom                               latest     1635fb73a24a   28 minutes ago   538MB
venkyacr1001.azurecr.io/sowmyavenky/mysql-custom       latest     1635fb73a24a   28 minutes ago   538MB <-- Note this.
paketobuildpacks/run                                   base-cnb   9d986bd5e914   3 days ago       88.8MB
mysql                                                  latest     a3a2968869cf   5 days ago       538MB
paketobuildpacks/builder                               base       4d66077a2347   42 years ago     1.32GB
sowmyavenky/spring-mysql-jpa                           latest     fdb45e6ae5b6   42 years ago     249MB
venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa   latest     fdb45e6ae5b6   42 years ago     249MB <-- Note this.

# Also we can list the images from the ACR with this command from laptop 
PS C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab05> az acr repository list --name venkyacr1001
[
  "sowmyavenky/mysql-custom",
  "sowmyavenky/spring-mysql-jpa"
]

# We can also see the extra attributes of an image like this
PS C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab05> az acr repository show  --name venkyacr1001 --image sowmyavenky/mysql-custom
{
  "changeableAttributes": {
    "deleteEnabled": true,
    "listEnabled": true,
    "readEnabled": true,
    "writeEnabled": true
  },
  "createdTime": "2022-12-05T15:49:16.7083789Z",
  "digest": "sha256:b646ef88b6e1fe1a5b96750b341578c81a0247241d087444be0d98b2855640f5",
  "lastUpdateTime": "2022-12-05T15:49:16.7083789Z",
  "name": "latest",
  "quarantineState": "Passed",
  "signed": false
}

## Make sure we can run the container from the azure container registry
## For this we need to create a network and start both containers with the same network ref
sudo docker network create venky-network
sudo docker network ls

sudo docker run --network venky-network --name=venkymysql -e MYSQL_ROOT_PASSWORD=Ganesh20022002  -p 3306:3306 -d venkyacr1001.azurecr.io/sowmyavenky/mysql-custom 
sudo docker run --network venky-network --name venkyfrontend -p 8080:8080 -d venkyacr1001.azurecr.io/sowmyavenky/spring-mysql-jpa:latest

## Make sure that the curl commands work. The main change here is that we are now using venkymysql to connect to the sql server instance 
## rather than using localhost as beore.
## Execute curl commands to make sure the entire solution is good. 

## Now we use docker compose to test
## Copy the docker-compose.yaml to the vm
sudo apt install -y docker-compose

##There is a problem with docker compose the database does not come up before the app and it keeps failing. So, we start each component 
sudo docker-compose up venkymysql
sudo docker-compose up server

#Issue curl commands to make sure it all works!

## We need to next review the ACI (Azure container instance) deployment YAML file. Need to change the region and the token value 
## as needed from the previous captures. 
## deploy the container group referencing the YAML from here.

.\1003-deploy-aci.ps1

## For some reason whatever i do mysql container just keeps on restarting. need to debug that.
## Test mysql container 
az container create -g 1-147315a1-playground-sandbox --name custommysql --image venkyacr1001.azurecr.io/sowmyavenky/mysql-custom --ip-address public --ports 3306 --command-line "tail -f /dev/null"
az container logs -g 1-147315a1-playground-sandbox --name custommysql
az container show -g 1-147315a1-playground-sandbox --name custommysql
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


## MySQL is not working for some reason inside ACI. I am trying with postgres instead since that seems to work fine. 
mkdir postgres-custom
cd postgres-custom
## Copy the postgres-docker-compose.yaml and rename it to docker-compose.yaml
## Skip the mysql section if we want to pursue mysql - but it is not working in ACI and move over to the app area.
## Start the postgres as a docker container to test app locally first.
sudo docker run -d --name venkypostgres -e POSTGRES_USER=venkyuser -e POSTGRES_DB=testdb -e POSTGRES_PASSWORD=Ganesh20022002 -p 5432:5432 postgres

##Check the container running 
venky@quickvm:~/postgres-custom/spring-mysql-jpa$ sudo docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                       NAMES
fd0e13f94e40   postgres   "docker-entrypoint.s…"   13 seconds ago   Up 10 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   venkypostgres

sudo docker logs venkypostgres 
# Check logs to make sure postgres is good

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
sudo mvn spring-boot:build-image _DskipTests=true -Dspring-boot.build-image.imageName=sowmyavenky/spring-jpa:latest

## Make sure that both the custom images are there
venky@quickvm:~/postgres-custom/spring-mysql-jpa$ sudo docker images
REPOSITORY                 TAG        IMAGE ID       CREATED        SIZE
paketobuildpacks/run       base-cnb   aaa2f1dd3ebf   5 hours ago    88.8MB
postgres                   latest     68f5d950dcd3   2 weeks ago    379MB
sowmyavenky/spring-jpa     latest     19ad5a91b10c   42 years ago   250MB <-- check this one. 
paketobuildpacks/builder   base       e7466b79959b   42 years ago   1.32GB

## Next we can test both postgres and spring jpa in one docker compose. 
## Stop postgres image first 
sudo apt install -y docker-compose
sudo docker-compose up 

venky@quickvm:~$ sudo docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS                   PORTS                                       NAMES
28ddd95c7d48   sowmyavenky/spring-jpa:latest   "/cnb/process/web"       4 minutes ago   Up 4 minutes             0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   postgres-custom_frontend_1
a244494b8dad   postgres:latest                 "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres-custom_venkypostgres_1

## As we can see the 2 containers are running fine. We can execute the curl commands above to validate and make sure the apps work.

## Next create the ACR 
.\1002-create-acr.ps1

##Sometimes we get error `Cannot autolaunch D-Bus without X11 $DISPLAY`
## to get rid of this use 
sudo apt-get install pass gnupg2

#### Get the token value from the powershell and set it as env var on vm, and then use that to login to the registry from the virtual machine.
export TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlFXRkc6TTIzNzpLMkhBOjMzREs6NVBHVDpDQTNNOkRCTjM6WE9RQjpBNVFCOkk2M1E6QVQzUTpOUUFLIn0.eyJqdGkiOiJmYjg3NmMyYS1mMmVmLTRjNDgtOGY1Zi02MjlkN2QxNjU5ZjkiLCJzdWIiOiJjbG91ZF91c2VyX3BfNWVkNmExN2FAYXp1cmVsYWJzLmxpbnV4YWNhZGVteS5jb20iLCJuYmYiOjE2NzAyOTE5NTMsImV4cCI6MTY3MDMwMzY1MywiaWF0IjoxNjcwMjkxOTUzLCJpc3MiOiJBenVyZSBDb250YWluZXIgUmVnaXN0cnkiLCJhdWQiOiJ2ZW5reWFjcjEwMDEuYXp1cmVjci5pbyIsInZlcnNpb24iOiIxLjAiLCJyaWQiOiIxMjc2NjFlNmIxN2U0ZTY3OGYwYzY0NzkxNDU2MzE4YyIsImdyYW50X3R5cGUiOiJyZWZyZXNoX3Rva2VuIiwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJ0ZW5hbnQiOiIzNjE3ZWY5Yi05OGI0LTQwZDktYmE0My1lMWVkNjcwOWNmMGQiLCJwZXJtaXNzaW9ucyI6eyJBY3Rpb25zIjpbInJlYWQiLCJ3cml0ZSIsImRlbGV0ZSIsImRlbGV0ZWQvcmVhZCIsImRlbGV0ZWQvcmVzdG9yZS9hY3Rpb24iXSwiTm90QWN0aW9ucyI6bnVsbH0sInJvbGVzIjpbXX0.M7T6gi5EYiO3OoFgnB-68Dc9Nnuw3kPfJToeAee_Qk5gso5o3GtS4_P3_6uJJE5twOftrkwoiG4gbYQq7s4z8CYP180XV3dV-i0cjVXXNgJLHaWU3RIvyJyPvNEuluwlf-vlxZMVEOzfPvMA1eOVFSH6n-ooQffXGxH3TZRFyqt23UWH81wkuDwezPpOGpphL8x2NU7cMvQHDJjQD0-nM3MQzTpZytZMV734-smyJ8YTvB8NYODB12zOrtQsMIIPVj-h238Go8XsAD0dFBSQyshPKbiXUNIQGfdJFXnFRtqNlSdIbvZU_nZjGnwPMpWb125yTiWyPmqXCpgVq8Cqaw
sudo docker login venkyacr1001.azurecr.io -u 00000000-0000-0000-0000-000000000000 -p $TOKEN

#Push mysql custom image. 
sudo docker tag postgres:latest venkyacr1001.azurecr.io/sowmyavenky/postgres:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/postgres:latest

#Push the spring boot app image. 
sudo docker tag sowmyavenky/spring-jpa:latest venkyacr1001.azurecr.io/sowmyavenky/spring-jpa:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/spring-jpa:latest

#After this we should have the images as shown below
venky@quickvm:~$ sudo docker images
REPOSITORY                                       TAG        IMAGE ID       CREATED        SIZE
paketobuildpacks/run                             base-cnb   aaa2f1dd3ebf   6 hours ago    88.8MB
postgres                                         latest     68f5d950dcd3   2 weeks ago    379MB
sowmyavenky/spring-jpa                           latest     19ad5a91b10c   42 years ago   250MB
venkyacr1001.azurecr.io/sowmyavenky/spring-jpa   latest     19ad5a91b10c   42 years ago   250MB <-- Note this
paketobuildpacks/builder                         base       e7466b79959b   42 years ago   1.32GB

# Also we can list the images from the ACR with this command from laptop 
PS C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab05> az acr repository list --name venkyacr1001
[
  "sowmyavenky/spring-jpa"
]

# We can also see the extra attributes of an image like this
PS C:\Venky\DP-203\Azure-AZ-204\microsoft-labs\Lab05> az acr repository show  --name venkyacr1001 --image sowmyavenky/spring-jpa
{
  "changeableAttributes": {
    "deleteEnabled": true,
    "listEnabled": true,
    "readEnabled": true,
    "writeEnabled": true
  },
  "createdTime": "2022-12-06T02:17:47.0407804Z",
  "digest": "sha256:b8a89bbb1f5f96c73e5c6d97a715ec36f9c27a13e643f4f943846b3ec35bcf2e",
  "lastUpdateTime": "2022-12-06T02:17:47.0407804Z",
  "name": "latest",
  "quarantineState": "Passed",
  "signed": false
}

## We need to next review the ACI (Azure container instance) deployment YAML file. Need to change the region and the token value 
## as needed from the previous captures. 
## deploy the container group referencing the YAML from here.

.\1003-deploy-aci.ps1

## Check the IP address of the ACI overview screen
curl -X POST http://40.78.126.43:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":1,"title":"Spring boot tutorial #1", "description":"This is the 1st in the series", "published": false}'
curl -X POST http://40.78.126.43:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":2,"title":"Spring boot tutorial #2", "description":"This is the 2nd in the series", "published": false}'
curl -X POST http://40.78.126.43:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":3,"title":"Spring boot tutorial #3", "description":"This is the 3rd in the series", "published": false}'
curl -X POST http://40.78.126.43:8080/api/tutorials   -H 'Content-Type: application/json' -d '{"id":4,"title":"Spring boot tutorial #4", "description":"This is the 4th in the series", "published": false}'
curl -X GET http://40.78.126.43:8080/api/tutorials; echo ""
curl -X GET http://40.78.126.43:8080/api/tutorials/1; echo ""
curl -X GET http://40.78.126.43:8080/api/tutorials/2; echo ""
curl -X GET http://40.78.126.43:8080/api/tutorials/3; echo ""
curl -X GET http://40.78.126.43:8080/api/tutorials/4; echo ""


######################## MYSQL SECTION ########################################
#Push mysql custom image. 
sudo docker tag sowmyavenky/mysql-custom:latest venkyacr1001.azurecr.io/sowmyavenky/mysql-custom:latest
sudo docker push venkyacr1001.azurecr.io/sowmyavenky/mysql-custom:latest

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

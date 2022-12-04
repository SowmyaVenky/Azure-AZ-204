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
sudo docker pull mysql/mysql-server:latest
sudo docker run --name=venkymysql -e MYSQL_ROOT_PASSWORD=Ganesh20022002  -p 3306:3306 -d mysql/mysql-server:latest
sudo docker exec -it venkymysql bash

## Run this inside bash
mysql -u root -p

## On the mysql prompt
create database testdb;
show databases;
CREATE USER 'venkyuser'@'%' IDENTIFIED BY 'Ganesh20022002';
GRANT ALL PRIVILEGES ON *.* TO 'venkyuser'@'%' WITH GRANT OPTION;

grant all on *.* to 'root'@'%';

## Sample springboot app with mysql 
sudo apt install wget unzip
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
sudo docker run -p 8080:8080 -t sowmyavenky/spring-mysql-jpa
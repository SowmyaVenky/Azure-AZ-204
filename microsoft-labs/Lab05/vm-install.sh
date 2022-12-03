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
sudo docker run --name=venkymysql -e MYSQL_ROOT_PASSWORD=Ganesh20022002 -d mysql/mysql-server:latest
sudo docker exec -it venkymysql bash

## Sample springboot app with mysql 
sudo apt install wget
sudo apt install -y default-jdk maven
mvn clean package

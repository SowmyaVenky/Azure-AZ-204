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
git clone https://github.com/spring-guides/gs-accessing-data-mysql.git
cd /home/venky/gs-accessing-data-mysql
rm -rf test initial
cd complete

sudo apt install wget
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz
tar xzf OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz
sudo mv jdk-17.0.1+12 /opt/

export JAVA_HOME=/opt/jdk-17.0.1+12
export PATH=$JAVA_HOME/bin:$PATH

sudo apt install -y default-jdk maven

#jdk 17
wget https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz
tar xvf openjdk-17+35_linux-x64_bin.tar.gz
sudo mv jdk-17*/ /opt/jdk17

sudo tee /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/opt/jdk17
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

source /etc/profile.d/jdk.sh


mvn clean package

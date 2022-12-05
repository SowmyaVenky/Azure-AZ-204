create database testdb;
show databases;
CREATE USER 'venkyuser'@'%' IDENTIFIED BY 'Ganesh20022002';
GRANT ALL PRIVILEGES ON *.* TO 'venkyuser'@'%' WITH GRANT OPTION;

grant all on *.* to 'root'@'%';
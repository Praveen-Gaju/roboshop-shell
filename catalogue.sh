#Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install NodeJS
yum install nodejs -y

#Configure the application. Add application User
useradd roboshop

#Lets setup an app directory.
mkdir /app

#remove existing files in directory.
rm -rf /app/*

#Download the application code to created app directory.
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

#Lets download the dependencies.
npm install

#copy configuration file.
cp config/catalogue.service /etc/systemd/system/catalogue.service

#Load the service and start the service.
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

#We need to load the schema. To load schema we need to install mongodb client.
#To have it installed we can setup MongoDB repo and install mongodb-client
cp config/mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y

#Load Schema
mongo --host mondodb.devopspract.online </app/schema/catalogue.js


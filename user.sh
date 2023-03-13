code_dir=$(pwd)

#Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install NodeJS
yum install nodejs -y

#Add roboshop user
useradd roboshop

#Lets setup app directory
mkdir /app

#Download the application code to created app directory.
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip

#Lets download the dependencies.
cd /app
npm install

#Copy user.service file to server
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service

#Load the service.
systemctl daemon-reload

#Start the service.
systemctl enable user
systemctl start user

#To have it installed we can setup MongoDB repo and install mongodb-client
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB shell
yum install mongodb-org-shell -y

#
mongo --host mondodb.devopspract.online </app/schema/user.js
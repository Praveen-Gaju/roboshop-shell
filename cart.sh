#Setup NodeJS repos. Vendor is providing a script to setup the repos.
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

#Install NodeJS
yum install nodejs -yum

#Add roboshop user to run application in roboshop user
useradd roboshop

#Make app directory
mkdir /app

#Download the application code to created app directory.
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip

#Lets download the dependencies.
cd /app
npm install

#load the service
systemctl daemon-reload

#Start the service
systemctl enable cart
systemctl start cart

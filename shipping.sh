
#Shipping service is written in Java, Hence we need to install Java and maven.
yum install maven -y

#Add application user
useradd roboshop

#Lets setup an app directory.
mkdir /app

#Download the application code to created app directory.
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

#Lets download the dependencies & build the application
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

#Load the service
systemctl daemon-reload

#Start the service
systemctl enable shipping
systemctl start shipping

#We need to load the schema. To load schema we need to install mysql client.
#To have it installed we can use
yum install mysql -y

#load schema
mysql -h mysql.devopspract.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

#Restart shipping service
systemctl restart shipping
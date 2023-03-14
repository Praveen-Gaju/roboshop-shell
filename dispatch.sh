code_dir=$(pwd)

#Install GoLang
yum install golang -y

#Add application user
useradd roboshop

#Setup app directory
mkdir /app

#Download the application code to created app directory.
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

#Download the dependencies & build the software.
cd /app
go mod init dispatch
go get
go build

#copy dispatch.service file to server
cp ${code_dir}/configs/dispatch.service /etc/systemd/system/dispatch.service

#load the service
systemctl daemon-reload

#start the service
systemctl enable dispatch
systemctl start dispatch
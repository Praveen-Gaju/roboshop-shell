code_dir=$(pwd)

#Install python 3.6
yum install python36 gcc python3-devel -y

#Add application User
useradd roboshop

#Lets setup an app directory.
mkdir /app

#Download the application code to created app directory.
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

#Lets download the dependencies.
cd /app
pip3.6 install -r requirements.txt

#copy payment.service file to server
cp ${code_dir}/configs/payment.service /etc/systemd/system/payment.service

#Load the service.
systemctl daemon-reload

#Start the service.
systemctl enable payment
systemctl start payment


code_dir=$(pwd)

#copy the MongoDB repo file
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB
yum install mongodb-org -y

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

#enable and start mongoDB
systemctl enable mongod

#Restart the service to make the changes effected.
systemctl restart mongod
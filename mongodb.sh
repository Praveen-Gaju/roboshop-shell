code_dir=$(pwd)

#copy the MongoDB repo file
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB
yum install mongodb-org -y

#enable and start mongoDB
systemctl enable mongod
systemctl start mongod

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

#Restart the service to make the changes effected.
systemctl restart mongod
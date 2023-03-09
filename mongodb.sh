#copy the MongoDB repo file
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

#Install MongoDB
yum install mongodb-org -y

#enable and start mongoDB
systemctl enable mongod
systemctl start mongod

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

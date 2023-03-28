source common.sh


#copy the MongoDB repo file
print_head "copying the MongoDB repo file"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

#Install MongoDB
print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
print_head "updating listening ports"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

#enable and start mongoDB
print_head "Enabling MongoDB"
systemctl enable mongod &>>${log_file}

#Restart the service to make the changes effected.
print_head "Restarting MongoDB"
systemctl restart mongod &>>${log_file}
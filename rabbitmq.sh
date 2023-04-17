source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing rabbitmq app user password argument\e[0m"
  exit 1
fi

#Configure YUM Repos from the script provided by vendor.
print_head "Setting up Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>{log_file}
status_check $?

#Configure YUM Repos for RabbitMQ.
print_head "Setting up rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>{log_file}
status_check $?

#Install RabbitMQ
print_head "Installing Rabbitmq & Erlang service"
yum install rabbitmq-server erlang -y &>>{log_file}
status_check $?

#Start RabbitMQ Service
print_head "Enabling Rabbitmq service"
systemctl enable rabbitmq-server &>>{log_file}
status_check $?

print_head "Starting Rabbitmq service"
systemctl start rabbitmq-server &>>{log_file}
status_check $?

#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect.
#Hence, we need to create one user for the application.
print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>{log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_password} &>>{log_file}
fi
status_check $?

#rabbitmqctl set_user_tags roboshop administrator
print_head "Configure permissions for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{log_file}
status_check $?
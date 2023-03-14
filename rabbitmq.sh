#Configure YUM Repos from the script provided by vendor.
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash

#Install Erlang
yum install erlang -y

#Configure YUM Repos for RabbitMQ.
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash

#Install RabbitMQ
yum install rabbitmq-server -y

#Start RabbitMQ Service
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect.
#Hence, we need to create one user for the application.
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
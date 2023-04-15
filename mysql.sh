source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo "\e[31mMissing MySql root Password argument\e[0m"
  exit 1
fi

#CentOS-8 Comes with MySQL 8 Version by default, However our application needs MySQL 5.7.
#So lets disable MySQL 8 version.
print_head "Disable mysql version 8"
dnf module disable mysql -y &>>${log_file}
status check $?

#Copy repo file to server
print_head "copy mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status check $?

#Install Mysql server
print_head "Installing mysql server"
yum install mysql-community-server -y &>>${log_file}
status check $?

#Start MySQL Service
print_head "Enabling mysql service"
systemctl enable mysqld &>>${log_file}
status check $?

print_head "Starting mysql service"
systemctl start mysqld &>>${log_file}
status check $?

#Next, We need to change the default root password in order to start using the database service.
#Use password RoboShop@1 or any other as per your choice.
print_head "Set root password"
echo show databases | mysqql -uroot -p${mysql_root_password} &>>${log_file}

if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status check $?

#You can check the new password working or not using the following command in MySQL.
# mysql -uroot -pRoboShop@1


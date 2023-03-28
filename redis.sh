source common.sh

#Redis is offering the repo file as a rpm. Lets install it.
print_head "Installing Redis Repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

#Enable Redis 6.2 from package streams.
print_head "Enabling Redis 6.2 from package"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

#Install Redis
print_head "Installing Redis"
yum install redis -y &>>${log_file}
status_check $?

#Update listen address from 127.0.0.1 to 0.0.0.0 in
print_head "updating listening ports in Redis conf file"
sed -i -e 's/127.0.0.1/0.0.0.0/ /etc/redis.conf /etc/redis/redis.conf' &>>${log_file}
status_check $?

#Start & Enable Redis Service
print_head "Enabling Redis"
systemctl enable redis &>>${log_file}
status_check $?

print_head "Starting Redis"
systemctl start redis &>>${log_file}
status_check $?
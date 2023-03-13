#Redis is offering the repo file as a rpm. Lets install it.
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

#Enable Redis 6.2 from package streams.
dnf module enable redis:remi-6.2 -y

#Install Redis
yum install redis -y

#Update listen address from 127.0.0.1 to 0.0.0.0 in


#Start & Enable Redis Service
systemctl enable redis
systemctl start redis
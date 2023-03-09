#Install Nginx
yum install nginx -y

#Remove the default content that web server is serving.
rm -rf /usr/share/nginx/html/*

#Download the frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

#Extract the frontend content.
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#copy nginx configuration file
cp configs/nginx-roboshop.conf etc/nginx/default.d/roboshop.conf

#Start & Enable Nginx service
systemctl enable nginx
systemctl restart nginx
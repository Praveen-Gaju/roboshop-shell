code_dir=$(pwd)
#Install Nginx
echo "\e[31m Installing Nginx \e[0m"
yum install nginx -y

#Remove the default content that web server is serving.
echo "\e[31m Removing default content in Web Server \e[0m"
rm -rf /usr/share/nginx/html/*

#Download the frontend content
echo "\e[31m Downloading Frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

#Extract the frontend content.
echo "\e[31m Extracting and unzip the frontend content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#copy nginx configuration file
echo "\e[31m Copy Nginx configuration file \e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf etc/nginx/default.d/roboshop.conf

#Start & Enable Nginx service
echo "\e[31m Restarting Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx



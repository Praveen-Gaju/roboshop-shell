source common.sh

#Install Nginx
print_head "Installing Nginx"
yum install nginx -y &>>${log_file}
status_check $?

#Remove the default content that web server is serving.
print_head "Removing default content in Web Server"
rm -rf /usr/share/nginx/html/*  &>>${log_file}
status_check $?

#Download the frontend content.
print_head "Downloading Frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

#Extract the frontend content.
print_head "Extracting and unzip the frontend content"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

#copy nginx configuration file.
print_head "Copy Nginx configuration file"
cp "${code_dir}"/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

#Start & Enable Nginx service
print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}
status_check $?

print_head "starting Nginx"
systemctl start nginx &>>${log_file}
status_check $?
code_dir=$(pwd)

#creating the log file and directing the logs of each step to log file
log_file=/tmp/roboshop.log
rm -f ${log_file} #every time script is executed it removes older log file and replace it with new log file

#function for printing the statement in color code
print_head() {
  echo -e "\e[36m$1\e[0m"
}

#to check the status of the previous code is success or failure
status_check() {
  if [ $1 -eq 0 ]; then
    echo Success
    else
    echo Failure
    echo "Read the log file ${log_file} for more information about error "
  fi
}

#system setup function
systemd_setup() {
    #Copy user.service file to server
    print_head "Copying SystemD service file"
    cp "${code_dir}"/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}" /etc/systemd/system/${component}.service &>>{log_file}

    #Load the service.
    print_head "Reload SystemD"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    #Start the service.
    print_head "Enable ${component} Service"
    systemctl enable ${component} &>>${log_file}
    status_check $?

    print_head "Start ${component} Service"
    systemctl start ${component} &>>${log_file}
    status_check $?

}

#Schema setup
schema_setup() {
  #to setup mongodb
  if [ "${schema_type}" == "mongo" ]; then
    #To have it installed we can setup MongoDB repo and install mongodb-client
      print_head "Copy MongoDB repo file"
      cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
      status_check $?

      #Install MongoDB shell
      print_head "Installing Mongo client"
      yum install mongodb-org-shell -y &>>${log_file}
      status_check $?

      #Load Schema
      print_head "Loading Schema"
      mongo --host mongodb-dev.devopspract.online </app/schema/${component}.js &>>${log_file}
      status_check $?

  #to setup mysql DB
  elif [ "${schema_type}" == "mysql" ]; then
    #Installing mysql
    print_head "Installing Mysql clinet"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql-dev.devopspract.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?
  fi
}


app_prereq_setup() {
    #to create roboshop user and extracting content files
    print_head "Create Roboshop User"
    id roboshop  &>>${log_file}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${log_file}
    fi
    status_check $?

    #Lets setup app directory
    print_head "Creating Application Directory"
    if [ ! -d /app ]; then
      mkdir /app &>>${log_file}
    fi
    status_check $?

    #delete old content
    print_head "Deleting old content"
    rm -rf /app/* &>>${log_file}
    status_check $?

    #Download the application code to created app directory.
    print_head "Downloading app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    status_check $?
    cd /app

    #Extract the App content from zip file
    print_head "Extracting app content"
    unzip /tmp/${component}.zip &>>{log_file}
    status_check $?
}

#NodeJS function
nodejs() {
  #Setup NodeJS repos. Vendor is providing a script to setup the repos.
  print_head "Configuring NodeJS repo file"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  #Install NodeJS
  print_head "Installing NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  #calling roboshop user setup function
  app_prereq_setup

  #Lets download the dependencies.
  print_head "Installing NodeJS dependencies"
  npm install &>>{log_file}
  status_check $?

  #calling schema setup function
  schema_setup

  #calling System setup function
  sys temd_setup
}

java() {
  print_head "Installing Maven"
  yum install maven -y &>>${log_file}
  status_check $?

  #calling app_prereq_setup fun ction
  app_prereq_setup

  print_head "Downloading Dependencies & Packages"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  #calling schema setup function
  schema_setup

  #calling System setup function
  systemd_setup
}

python() {
  #Install python 3.6
  print_head "Installing Python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  status_check $?

  app_prereq_setup

  #Lets download the dependencies.
  print_head "Downloading Dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  status_check $?

  systemd_setup
}

golang() {
  #Install GoLang
  print_head "Installing golang"
  yum install golang -y &>>${log_file}
  status_check $?

  #load app function
  app_prereq_setup

  #Download dependencies
  print_head "Downloading golang dependencies"
  go mod init dispatch &>>${log_file}
  go get &>>${log_file}
  go build &>>${log_file}
  status_check $?

  #loadthe service file
  systemd_setup
}
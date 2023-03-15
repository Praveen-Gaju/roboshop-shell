code_dir=$(pwd)

#creating the log file and directing the logs of each step to log file
log_file=/tmp/roboshop.log
rm -f ${log_file} #every time script is executed it removes older log file and replace it with new log file

#function for printing the statement in color code
print_head() {
  echo -e "\e[36m$1\e[0m"
}

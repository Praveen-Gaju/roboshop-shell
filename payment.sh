source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing app password\e[0m"
  exit 1
fi


component=payment
python





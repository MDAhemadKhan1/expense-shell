#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Check_Root()
{
if [ $USERID -ne 0 ]
then
  echo -e $R "you must have root access to execute this script" $N
  exit 1
fi
}


Validate(){
if [ $1 -ne 0 ]
then
   echo -e "$2.....$R Failure $N"
   exit 1 
else
   echo -e "$2......$R Success $N"
fi 
} 

Check_Root

dnf install nginx -y
Validate $? "Installing Nginx......."


systemctl enable nginx
Validate $? "Enabling Nginx......"


systemctl start nginx
Validate $? "Starting Nginx......"


rm -rf /usr/share/nginx/html/*
echo " removing the default content....."

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
Validate $? "Downloading the frontend....."

cd /usr/share/nginx/html
Validate $? "switching to other directory......" 

unzip /tmp/frontend.zip
Validate $? "unzipping the frontend....."

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
Validate $? "Copying the configuration....."

systemctl restart nginx
Validate $? "restarting the Nginx.............. "



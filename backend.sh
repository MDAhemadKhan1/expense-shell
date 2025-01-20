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

dnf module disable nodejs -y
Validate $? "Disabling nodesjs...."

dnf module enable nodejs:20 -y
Validate $? "Enabling nodejs20...."

dnf install nodejs -y
Validate $? "Installing nodejs....."

id expense
if [ $? -ne 0 ]
then
  useradd expense
  Validate $? "Addind User ...."
  echo " User Added successfully...."
else
  echo " User already exist......SO SKIPPING "
fi

mkdir -p /app
Validate $? "Creating app Directory....."

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
Validate $? "Downloading the backend...."

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
Validate $? "Unzipping the file....."

npm install
Validate $?"Installing the dependencies...."

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service
Validate $? "Copying the configuration....."

dnf install mysql -y
Validate $? "Installing My Sql Client........"


mysql -h 44.201.134.249 -uroot -pExpenseApp@1 < /app/schema/backend.sql
Validate $? "Loading the schema and tables....."

systemctl daemon-reload
Validate $? "Re-Loading...."

systemctl start backend
Validate $? "Starting backend......."

systemctl enable backend
Validate $? "Enabling backend........"









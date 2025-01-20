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

dnf install mysql-server -y
Validate $? "Installing MySql....."

systemctl enable mysqld
Validate $? "Enabling MySql....."

systemctl start mysqld
Validate $? "Starting MySql......"

mysql -h 44.201.134.249 -u root -p ExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
  echo " root password id not setup..." 
  mysql_secure_installation --set-root-pass ExpenseApp@1
  Validate $? "Setting the Root Password....."
  exit 1
else
  echo -e $Y " Root password setup is already done SO SKIPPING " $N 
fi  
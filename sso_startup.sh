#!/bin/bash

if [ ! -f bashlog.out ];
then
   echo "Create bashlog.out logfile from sso_startup shell, on $(date +%F-%T)" > bashlog.out
fi

echo "SSO_STARTUP run on $(date +%F-%T)  ===========================" >> bashlog.out

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
      echo "Please enter a file with required AWS account profile names" 
      read keep_going
      return -1
fi

awsProfile=$1
echo "${awsProfile} is the file used to list aws profiles" >> bashlog.out


if [ -f ${awsProfile} ]; 
then
    echo "${awsProfile} exists." >> bashlog.out

else 
    echo Please enter a valid AWS profile input file
    read keep_going
    return -2
fi

while read profile; 
do 
   aws sso login --profile $profile >> bashlog.out &

done < ${awsProfile}

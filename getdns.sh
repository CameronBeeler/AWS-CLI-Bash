#!/bin/bash

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
   echo "Please enter a file with required AWS account profile names"
   exit -1
fi

$AWS_Profile=$1

if [ -f "$AWS_Profile" ]; then
    echo "$AWS_Profile exists."

    else 
    echo "Please enter a valid AWS profile input file"
    exit -2
fi

echo "in the following steps, you will need to approve each profile CLI on your web browser before action can be taken"

while read -r profile; 
do 
   aws sso login --profile $profile
   echo your profile is $profile
   echo "AFTER YOU HAVE APPROVED the SSO CLI auth, please press ENTER"
   input trash_enter

   if [ $trash_enter -eq 'exit' ]
   then
      exit -3
   fi
   
   accountDomains=${profile}.domains
   > ${accountDomains}

   while read domainId ; 
   do
#     read in the domain.  
      echo ${profile}.${domainId} >> ${accountDomains}

      while read hostedZone;
      do
         echo ${hostedZone} >> ${profile}.${domainId}
         
      done < <(aws route53 list-resource-record-sets --hosted-zone-id ${domianId} --output json --profile ${profile} |jq -jr '.ResourceRecordSets[] | "\(.Type) \t\(.Name) \t\(.ResourceRecords[]?.Value)\n"'|sort;exit)
    
   done < <(aws route53 list-hosted-zones --profile ${profile} --output json | jq '.[]|.[]|.Id'|sed 's:"/hostedzone/::'|sed 's:"$::'; exit)
done < $AWS_profile

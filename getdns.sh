#!/bin/bash

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
   echo "Please enter a file with required AWS account profile names"
   read keep_going
#   kill -INT $$
   return -1
fi

awsProfile=$1
echo ${awsProfile}


if [ -f "${awsProfile}" ]; then
    echo "$awsProfile exists."

else 
    echo "Please enter a valid AWS profile input file"
    read keep_going
    return -2
fi

echo "in the following steps, you will need to approve each profile CLI on your web browser before action can be taken"

while read profile; 
do 
   aws sso login --profile $profile
   accountDomains=${profile}.domains
   > ${accountDomains}
echo ${accountDomains} domain file has been successfully created

   while read domainId ; 
   do

#     read in the domain.  
      hzFileName=${profile}.${domainId}
      > $hzFileName
      echo ${hzFileName} >> ${accountDomains}


           while read hostedZone;
           do
              echo ${hostedZone} >> ${hzFileName}
           done < <(aws route53 list-resource-record-sets --hosted-zone-id ${domainId} --output json --profile ${profile} |jq -jr '.ResourceRecordSets[] | "\(.Type) \t\(.Name) \t\(.ResourceRecords[]?.Value)\n"'|sort; exit)
    
      done < <(aws route53 list-hosted-zones --profile ${profile} --output json | jq '.[]|.[]|.Id'|sed 's:"/hostedzone/::'|sed 's:"$::'; exit)
done < $awsProfile

for nodomains in *.domains; do if [ ! -s ${nodomains} ]; then rm ${nodomains}; fi; done

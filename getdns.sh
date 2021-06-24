#!/bin/bash

echo "GETDNS executed on $(date +%F-%T) ====================" >> bashlog.out

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
   echo "Please enter a file with required AWS account profile names"
   read keep_going
   return -1
fi

awsProfile=$1
echo ${awsProfile} >> bashlog.out


if [ -f "${awsProfile}" ]; then
    echo "$awsProfile exists.">> bashlog.out

else 
    echo "Please enter a valid AWS profile input file"
    read keep_going
    return -2
fi

while read profile; 
do 
   accountDomains=${profile}.domains
   echo "reset the ${accountDomains} file to null" >> bashlog.out
   > ${accountDomains}
   echo ${accountDomains} domain file has been successfully created >> bashlog.out

   while read domainId ; 
   do

#     read in the domain.  
      hzFileName=${profile}.${domainId}.rrs
      echo "reset the ${hzFileName} file to null" >> bashlog.out
      > $hzFileName
      echo "-----adding ${hzFileName} to ${accountDomains}" >> bashlog.out
      echo ${hzFileName} >> ${accountDomains} 


           while read hostedZone;
           do
              echo "==== ${hostedZone} added to ${hzFileName}" >> bashlog.out
              echo ${hostedZone} >> ${hzFileName}
           done < <(aws route53 list-resource-record-sets --hosted-zone-id ${domainId} --output json --profile ${profile} |jq -jr '.ResourceRecordSets[] | "\(.Type) \t\(.Name) \t\(.ResourceRecords[]?.Value)\n"'|sort; exit)
    
      done < <(aws route53 list-hosted-zones --profile ${profile} --output json | jq '.[]|.[]|.Id'|sed 's:"/hostedzone/::'|sed 's:"$::'; exit)
done < $awsProfile

for nodomains in *.domains; 
do 
   if [ ! -s ${nodomains} ]; 
   then 
      echo "Remove the empty file ${nodomains}" >> bashlog.out
      rm ${nodomains}; 
   fi; 
done

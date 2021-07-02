#!/bin/bash

if [ ! -f bashlog_dns.out ];
then
   echo "$(date +%Y%m%d::%H%M) -  Create bashlog_dns.out logfile from getdns shell" > bashlog_dns.out
fi


echo "$(date +%Y%m%d::%H%M) - GETDNS executed ====================" >> bashlog_dns.out

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
   echo "Please enter a file with required AWS account profile names"
   read keep_going
   return -1
fi

#
# Create a final destination for all of the dns files
#
destination="./$(date +%Y%m%d_%H%M%S.dns_cleanup)/"
mkdir ${destination}

#
# Name the sso input file
#
ssoProfileInputFile=$1
echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile}" >> bashlog_dns.out


if [ -f "${ssoProfileInputFile}" ]; then
    echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile} exists.">> bashlog_dns.out

else 
    echo "Please enter a valid AWS profile input file"
    read keep_going
    return -2
fi

while read ssoAccountProfileName; 
do 
   accountDomains=${ssoAccountProfileName}.domains
   echo "$(date +%Y%m%d::%H%M) -  reset the ${accountDomains} file to null" >> bashlog_dns.out
   echo "$(date +%Y%m%d::%H%M) -  ${accountDomains} domain file has been successfully created." >> bashlog_dns.out

   while read hostZoneInfo ; 
   do

#
#     read in the domain Id and the domain Name for file naming purposes.  
#
      domainId=$(echo ${hostZoneInfo}|cut -d' ' -f1)
      domainName=$(echo ${hostZoneInfo}|cut -d' ' -f2|sed 's:.$::')
      hzFileName=${domainName}_${domainId}.rrs
      echo "$(date +%Y%m%d::%H%M) -  reset the ${hzFileName} file to null." >> bashlog_dns.out
      > ${hzFileName}
      echo "$(date +%Y%m%d::%H%M) -  -----adding ${hzFileName} to ${accountDomains}." >> bashlog_dns.out
      echo ${hzFileName} >> ${accountDomains} 


           while read hostedZone;
           do
              echo "$(date +%Y%m%d::%H%M) -  ==== ${hostedZone} added to ${hzFileName}." >> bashlog_dns.out
              echo ${hostedZone} >> ${hzFileName}
           done < <(aws route53 list-resource-record-sets --hosted-zone-id ${domainId} --output json --profile ${ssoAccountProfileName} |jq -jr '.ResourceRecordSets[] | "\(.Type) \t\(.Name) \t\(.ResourceRecords[]?.Value)\n"'|sort; exit)

    
   done < <(aws route53 list-hosted-zones --profile ${ssoAccountProfileName} --output json | jq -jr '.[] |.[]|"\(.Id) \t\(.Name)\n"'|sed 's:/hostedzone/::'; exit)


done < <(cat ${ssoProfileInputFile})

# POST processing file manipulation and data massaging

for nodomains in *.domains; 
do 
   if [ ! -s ${nodomains} ]; 
   then 
      echo "$(date +%Y%m%d::%H%M) -  Remove the empty file ${nodomains}." >> bashlog_dns.out
      rm ${nodomains}  >> bashlog_dns.out
   fi; 
done

for rrsFilename in *.rrs;
do
   echo "$(date +%Y%m%d::%H%M) - ${addRecordsToFilename} is the file to move to directory ${destination}" >> bashlog_dns.out
   mv ${rrsFilename} $(cat ${rrsFilename} | wc -l|sed 's:[ ]*::').${rrsFilename} >> bashlog_dns.out
done

mv bashlog_dns.out ${destination}. >> bashlog_dns.out
mv *.domains ${destination}. >> bashlog_dns.out
mv *.rrs ${destination}. >> bashlog_dns.out

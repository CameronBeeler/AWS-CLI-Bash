#!/bin/bash

if [ ! -f bashlog_eip.out ];
then
   echo "$(date +%Y%m%d::%H%M) -  Create bashlog_eip.out logfile from geteip shell" > bashlog_eip.out
fi


echo "$(date +%Y%m%d::%H%M) - GETDNS executed ====================" >> bashlog_eip.out

# read the input file (account profile name)
if [ $# -ne 2 ]
   then
   echo "Please enter one file with required AWS account profile names and one file with required regions to be collected"
   echo "Format is:  . geteip.sh profiles.in regions.in"
   read keep_going
   return -1
fi

#
# Create a final destination for all of the eip records
# Example:
#    ./20210705_132524.eip_records/
#
destination="./$(date +%Y%m%d_%H%M%S.eip_records)/"
mkdir ${destination}

#
# Name the sso-profiles input file
#

ssoProfileInputFile=$1
echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile} is the AWS accounts profile input file" >> bashlog_eip.out

RegionsInputFile=$2
echo "$(date +%Y%m%d::%H%M) -  ${RegionsInputFile} is the regions input file" >> bashlog_eip.out


if [ -f "${ssoProfileInputFile}" ]; then
    echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile} exists.">> bashlog_eip.out
else 
    echo "Please enter a valid AWS profile input file"
    read keep_going
    return -2
fi

if [ -f "${RegionsInputFile}" ]; then
    echo "$(date +%Y%m%d::%H%M) -  ${RegionsInputFile} exists.">> bashlog_eip.out
else 
    echo "Please enter a valid AWS regions input file"
    read keep_going
    return -3
fi

#
# Create an output file for all EIP resources in the target AWS accounts(x profile) and respective target regions
# File will be ElasticIP_Collection.out
#

  eipRecordCounter=0
> ElasticIP_Collection.out
  echo "$(date +%Y%m%d::%H%M) -  ElasticIP_Collection.out file has been successfully created." >> bashlog_eip.out

#
# Format for the EIP records will be as follows
# Example:
#    account region EIP
#    my_aws_account_profile us-west-2 25.17.72.18
#

#
# get the sso profile in the outer loop, target regions in the next inner loop and then pull the EIP resources for each account+region
#

while read ssoAccountProfileName; 
do 
   echo "$(date +%Y%m%d::%H%M) -  Collecting EIP's from profile ${ssoAccountProfileName}" >> bashlog_eip.out

   while read AWSRegion ; 
   do
       eipRecordCounter=0
       while read eip_record associd_record;
       do
           insertRecord="${ssoAccountProfileName} ${AWSRegion} ${eip_record} ${associd_record}"
           echo ${insertRecord} >> ElasticIP_Collection.out
           eipRecordCounter=$(expr $eipRecordCounter + 1)
       done < <(aws ec2 describe-addresses --region ${AWSRegion} --profile ${ssoAccountProfileName} --output json|jq -c '.[]|.[]|[.PublicIp,.AssociationId]|@sh'|sed 's:"::g'|sed "s:'::g";exit)
           echo "$(date +%Y%m%d::%H%M) -  ${eipRecordCounter} EIP's in ${ssoAccountProfileName} $AWSRegion" >> bashlog_eip.out
           if [ ${eipRecordCounter} -gt 0 ] ;
           then
              RecordList+=("${eipRecordCounter} EIP's in ${ssoAccountProfileName} $AWSRegion")
           fi

   done < <(cat ${RegionsInputFile})

done < <(cat ${ssoProfileInputFile})


#
# POST processing file manipulation and data massaging
#

echo >> bashlog_eip.out
echo "${#RecordList[@]} regions x accounts records collected" >> bashlog_eip.out
echo "====================================================" >> bashlog_eip.out
TotalRecords=0

for ((i=0 ; i < ${#RecordList[@]} ; i++)); 
do
      TotalRecords=$(( TotalRecords + $( echo ${RecordList[i]}|cut -d' ' -f1 )))

done

echo >> bashlog_eip.out
echo "=====================================" >> bashlog_eip.out
echo "${TotalRecords} are the Total EIP Records"  >> bashlog_eip.out
echo "=====================================" >> bashlog_eip.out

mv bashlog_eip.out ${destination}. >> bashlog_eip.out
mv ElasticIP_Collection.out ${destination}. >> bashlog_eip.out
rm bashlog_eip.out

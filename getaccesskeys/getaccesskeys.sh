#!/bin/bash

##  GETACCESSKEYS bash and AWS CLI pplication
#   Application process flow documentation
#   1. Import an AWS Account ".in" file.  IAM is a global service, so no need for regions...
#   2. aws cli in a loop to obtain the Account Profile (Account is authorized via SSO prior to run of this bash application)
#   3. Embedded loop to sequentially identify every IAM account name
#   4. Another loop, leveraging the IAM account name to pull any access keys with their respective creation date and last used date and post those into a file
#   5. The file will require the AWS Account name, The IAM user name, and any access keys that might belong to that user.
#   Caveats...Might want all usernames.  Might only want usernames with one or more access keys.  
# States for the access keys
# Active
# Inactive
# number of days since creation?



if [ ! -f getaccesskey_log.out ];
then
   echo "$(date +%Y%m%d::%H%M) -  Create getaccesskey_log.out logfile from geteip shell" > getaccesskey_log.out
fi


echo "$(date +%Y%m%d::%H%M) - GETACCESSKEYS executed ====================" >> getaccesskey_log.out

# read the input file (account profile name)
if [ $# -ne 1 ]
   then
   echo "Please enter one file with required AWS account profile names"
   echo "Format is:$ . getaccesskeys.sh sso_accounts.in"
   read keep_going
   return -1
fi

#
# Create a final destination for all of the accesskey records
# Example:
#    ./20210705_132524.eip_records/
#
destination="./$(date +%Y%m%d_%H%M%S.ak_records)/"
mkdir ${destination}

#
# Name the sso-profiles input file
#

ssoProfileInputFile=$1
echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile} is the AWS accounts profile input file" >> getaccesskey_log.out

if [ -f "${ssoProfileInputFile}" ]; then
    echo "$(date +%Y%m%d::%H%M) -  ${ssoProfileInputFile} exists.">> getaccesskey_log.out
else 
    echo "Please enter a valid AWS profile input file"
    read keep_going
    return -2
fi

#
# Create an output file for all access key resources in the target AWS accounts(x profile)
# File will be AccessKey_Collection.out
#
  RecordList=();
  TotalRecords=0;
  accessKeyRecordCounter=0;
> AccessKey_Collection.out
  echo "$(date +%Y%m%d::%H%M) -  AccessKey_Collection.out file has been successfully created." >> getaccesskey_log.out;

#
# Format for the access key records will be as follows
# Example:
#    account 
#    IAM name
#    AccessKey  Age
#    AccessKey  Age
#

#
# get the sso profile in the outer loop, target IAM names in the next inner loop and then pull the Access Keys in the final loop
#

while read ssoAccountProfileName; 
do 
   echo "$(date +%Y%m%d::%H%M) -  Collecting IAM User Names from profile ${ssoAccountProfileName}" >> getaccesskey_log.out

   while read IAMUserName ; 
   do
       accessKeyRecordCounter=0
       while read user key status createdate ;
       do
#
#   Create date logic to identify number of days since the 'createdate' for the key
#
            
            insertRecord="${createdate} ${status} ${user} ${key} ${ssoAccountProfileName}";
            echo ${insertRecord} >> AccessKey_Collection.out;
            accessKeyRecordCounter=$(expr $accessKeyRecordCounter + 1);
       done < <(aws iam list-access-keys --user-name ${IAMUserName} --profile ${ssoAccountProfileName} --output json|jq -c '.[]|.[]|[.UserName, .AccessKeyId, .Status, .CreateDate]|@sh'|sed 's:\(.*\)T[0-9\:\+]*:\1:g'|sed "s:[\'\"]::g";exit)
            echo "$(date +%Y%m%d::%H%M) -  ${accessKeyRecordCounter} Access Keys in ${ssoAccountProfileName} ${IAMUserName}" >> getaccesskey_log.out
            if [ ${accessKeyRecordCounter} -gt 0 ] ; then
                RecordList+=("${accessKeyRecordCounter} access keys in ${ssoAccountProfileName} ${IAMUserName}")
            fi

   done < <(aws iam list-users --profile ${ssoAccountProfileName} --output json|jq -c '.[]|.[]|[.UserName]|@sh'|sed 's:"::g'|sed "s:'::g")
    
done < <(cat ${ssoProfileInputFile})

#
# POST processing file manipulation and data massaging
#

echo >> getaccesskey_log.out
echo "${#RecordList[@]} IAM accounts with access keys - collected" >> getaccesskey_log.out
echo "====================================================" >> getaccesskey_log.out
TotalRecords=0

for ((i=0 ; i < ${#RecordList[@]} ; i++)); 
do
      TotalRecords=$(( TotalRecords + $( echo ${RecordList[i]}|cut -d' ' -f1 )))

done

echo >> getaccesskey_log.out
echo "=====================================" >> getaccesskey_log.out
echo "${TotalRecords} are the Total access key Records located"  >> getaccesskey_log.out
echo "=====================================" >> getaccesskey_log.out

mv getaccesskey_log.out ${destination} >> getaccesskey_log.out
mv AccessKey_Collection.out ${destination} >> getaccesskey_log.out
rm getaccesskey_log.out

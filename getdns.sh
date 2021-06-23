#!/bin/bash

# read the input file (account profile name)
if [ $# -eq 0 ]
   then
   echo "Please enter a file with required AWS account profile names"
fi

$FILE=$1

if [ -f "$FILE" ]; then
    echo "$FILE exists."
fi

while read -r line; 
do 
   aws sso login --profile $line&
   while read line ; do
    ...
   done < <( commands producing the input)
done < $1

<H1> SSO_STARTUP </H1>
<p>
This is an SSO setup bash loop that takes a file-list of your AWS CLI SSO config profiles for SSO startup
<ul>
1. Requires the current AWS CLI
2. Requires the use of SSO tokens, and each account configured using SSO
3. Requires a text file that has a list of your 'one to many' SSO profile names for your accounts.
4. Requires a manual 'Approve' in your default browser for each SSO profile login
the command line format:
</ul>
. sso_startup.sh your_profile_file.any
</p>

GETDNS
This is a discovery script. It is meant to review Route53 domains &
hosted-zones for one or many identified AWS Accounts.

1. Pre-requisite of all accounts you are discovering to have SSO credentials active
   on the terminal and included within the profile input account

2. It is noteworthy that the SSO_STARTUP script also in this repository can
   be used to initiate your SSO credentials in your terminal using the same
   profile account input file of your making...

3. You will need a text file with your list of discovery aws config profile names

command line format
. getdns.sh your_profile_file.input

GETEIP
This is a discovery script. It is meant to collect all Elastic IP addresses
from all profile accounts and all regions described in the respective input accounts

1. Pre-requisite of all accounts you are discovering to have SSO credentials active
   on the terminal and included within the profile input account

2. It is noteworthy that the SSO_STARTUP script also in this repository can
   be used to initiate your SSO credentials in your terminal using the same
   profile account input file of your making...

3. You will need a text file with your list of discovery aws config profile names

4. You will need a text file with your list of regions to search within
   command line format
   . getdns.sh your_profile_file.input your_regions_file.input

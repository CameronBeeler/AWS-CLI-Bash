aws configservice put-config-rule --cli-input-json file://restricted-ssh.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://no-unrestricted-route-to-igw.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-ebs-encryption-by-default.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-security-group-attached-to-eni.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-volume-inuse-check.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://eip-attached.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://acm-certificate-expiration-check.json --profile hydrawise-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://restricted-ssh.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://no-unrestricted-route-to-igw.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://ec2-ebs-encryption-by-default.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://ec2-security-group-attached-to-eni.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://ec2-volume-inuse-check.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://eip-attached.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://acm-certificate-expiration-check.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://root-account-mfa-enabled.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://account-part-of-organizations.json --profile hydrawise-dev --region ap-southeast-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hydrawise-dev --region us-east-1


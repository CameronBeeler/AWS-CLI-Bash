aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://root-account-mfa-enabled.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://account-part-of-organizations.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://restricted-ssh.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://no-unrestricted-route-to-igw.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-ebs-encryption-by-default.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-security-group-attached-to-eni.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-volume-inuse-check.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://eip-attached.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://acm-certificate-expiration-check.json --profile imms --region us-west-2
aws configservice put-config-rule --cli-input-json file://restricted-ssh.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://no-unrestricted-route-to-igw.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://ec2-ebs-encryption-by-default.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://ec2-security-group-attached-to-eni.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://ec2-volume-inuse-check.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://eip-attached.json --profile imms --region us-east-1
aws configservice put-config-rule --cli-input-json file://acm-certificate-expiration-check.json --profile imms --region us-east-1

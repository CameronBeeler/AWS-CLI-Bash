aws configservice put-config-rule --cli-input-json file://restricted-ssh.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://no-unrestricted-route-to-igw.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-ebs-encryption-by-default.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-security-group-attached-to-eni.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://ec2-volume-inuse-check.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://eip-attached.json --profile hydrawise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://root-account-mfa-enabled.json --profile hydrawise-prod --region us-west-2

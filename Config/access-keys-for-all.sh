aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-ops --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-dev --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-security --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-marketing --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-swd-tools --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile hunter-swd-master --region us-east-1
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile enterprise-prod --region us-west-2
aws configservice put-config-rule --cli-input-json file://access-keys-rotated.json --profile enterprise-dev --region us-west-2
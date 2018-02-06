#!/bin/sh
#cd .kitchen/kitchen-terraform/$KITCHEN_SUITE-$KITCHEN_PLATFORM
hostname=$(terraform output public_ip)
res=$(curl $hostname | grep "Testing 123" | wc -c)
printf "The value recovered is: "+$res
printf "The hostname is: $hostname\n"
echo "The response is: $res";
printf "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "Executing tests"
inspec exec /Users/jose.choque/Documents/GitHub/terraform-training/basic.instance.ssh.good/specs/base_spec.rb -t ssh://ubuntu@$hostname -i /Users/jose.choque/AWS-KeyPairs/JoseTest_KeyPair.pem
response=$?
echo "The command execution status is -> $response"
printf "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
exit $response;
# if [ $res = "0" ]; then
#   exit 1
# else
#   exit 0
# fi
#!/bin/bash

# for tomcat, port 80 and port 8080 need to be opened
# this script allows you to do that.

#check if aws cli exists, bail otherwise
command -v aws >/dev/null 2>&1 || { echo "I require AWS CLI but it's not installed (e.g using apt-get install awscli).  Aborting." >&2; exit 1; }

usage() {
    echo "
---
This quick and dirty script allows HTTP traffic to flow from your current IP Address to 
an EC2 instance by modifying the security group.

TODO: need to detect and remove any prior ips as well on the lines of my other script.

USAGE:
$0 [AWS REGION] [AWS SECURITY GROUP]
- AWS REGION: the region where your security group is
- AWS SECURITY GROUP - the ID of your security group 
---
"

}

addIpAddr() {
    ip=$1
    port=$2
    if [[ ! "$ip" =~ "/32" ]]; then
        ip="${1}/32"
    fi
    echo "-- adding $ip to security group for tcp port $port"
    set -x
    aws ec2 authorize-security-group-ingress --group-name $AWS_SECURITYGROUP --region $AWS_REGION --cidr $ip --protocol tcp --port $port
    set +x
}

AWS_REGION=$1
AWS_SECURITYGROUP=$2
echo "-- region $1, security group $2"
if [[ -z $AWS_REGION || -z $AWS_SECURITYGROUP ]]; then
    usage && exit
fi

MY_IPADDR=$(wget http://ipinfo.io/ip -qO -)
echo "--current IP: $MY_IPADDR"

if [[ $MY_IPADDR == "" ]]; then
    echo "could not determine current public IP; cannot proceed!" && exit 1
fi 

currentPorts=$(aws ec2 describe-security-groups \
                   --region $AWS_REGION \
                   --group-names $AWS_SECURITYGROUP \
                   --query "SecurityGroups[].IpPermissions[].FromPort[]" \
                   --output text)

echo "-- current 'from' ports: $currentPorts"

if [[ $currentPorts =~ "80" && $currentPorts =~ "8080" ]]; then
    echo "-- 80, 8080 ports already added!"
else
    addIpAddr ${MY_IPADDR}/32 80
    addIpAddr ${MY_IPADDR}/32 8080
fi

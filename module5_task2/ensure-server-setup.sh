#!/bin/bash
# Get the instance with this public IP address
ec2InstanceId=$(aws ec2 describe-instances --filters "Name=ip-address,Values=$1" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Wait on this ec2 instance to be ready before trying to SSH into it
aws ec2 wait instance-running --instance-ids $ec2InstanceId

# Add this server as a known host
ssh-keyscan -H "$1" >> ~/.ssh/known_hosts

sleep 30

ssh ubuntu@"$1" "
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install docker.io unzip -y
    sudo systemctl start docker
    sudo systemctl emable docker
    sudo usermod -aG docker ubuntu
"

echo "$1" > new_ec2_instance_ip.txt
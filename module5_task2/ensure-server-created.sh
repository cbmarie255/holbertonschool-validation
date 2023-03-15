#!/bin/bash

# Create the EC2 instance and print the public IP address
aws ec2 run-instances \
	--image-id ami-09cd747c78a9add63 \
	--instance-type t2.micro \
	--subnet-id subnet-0bae4711d45d53358 \
	--security-group-ids sg-04100bb59c5a791bd \
	--key-name awesome-key \
	--query 'Instances[*].InstanceId' \
	--output text \
| xargs -I {} aws ec2 describe-instances \
	--instance-ids {} \
	--query 'Reservations[*].Instances[*].PublicIpAddress' \
	--output text
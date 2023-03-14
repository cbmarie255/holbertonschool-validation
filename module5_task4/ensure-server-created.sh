#!/bin/bash

# Create the EC2 instance and print the public IP address
aws ec2 run-instances \
	--image-id ami-0568936c8d2b91c4e \
	--instance-type t2.micro \
	--subnet-id subnet-013affb718a597ad0 \
	--security-group-ids sg-01e234840d346627e \
	--key-name awesome-key \
	--query 'Instances[*].InstanceId' \
	--output text \
| xargs -I {} aws ec2 describe-instances \
	--instance-ids {} \
	--query 'Reservations[*].Instances[*].PublicIpAddress' \
	--output text
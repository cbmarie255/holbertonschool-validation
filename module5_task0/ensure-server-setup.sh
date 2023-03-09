#!/bin/bash

ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/awesome-key.pem ubuntu@"$1" "
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install docker.io -y
    sudo systemctl start docker
    sudo systemctl emable docker
    sudo usermod -aG docker ubuntu
"
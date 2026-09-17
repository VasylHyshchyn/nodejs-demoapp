#!/bin/bash

sudo yum -y update
sudo yum -y install docker
sudo yum -y install git

sudo systemctl start docker

mkdir -p /opt/app
cd /opt/app
git clone https://github.com/benc-uk/nodejs-demoapp.git
cd nodejs-demoapp
sudo docker pull ghcr.io/benc-uk/nodejs-demoapp:latest
sudo docker tag ghcr.io/benc-uk/nodejs-demoapp:latest nodejs-demoapp:latest


sudo docker build -t nodejs-demoapp:latest .

sudo docker run -d \
  --name nodejs-demoapp \
  -p 3000:3000 \
  nodejs-demoapp:latest
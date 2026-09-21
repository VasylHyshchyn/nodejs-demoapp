#!/bin/bash

sudo yum -y update
sudo yum -y install docker


sudo systemctl start docker

sudo docker pull ghcr.io/benc-uk/nodejs-demoapp:latest
sudo docker tag ghcr.io/benc-uk/nodejs-demoapp:latest nodejs-demoapp:latest


sudo docker run -d \
  --name nodejs-demoapp \
  -p 3000:3000 \
  nodejs-demoapp:latest
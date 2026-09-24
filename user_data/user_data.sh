#!/bin/bash

sudo yum -y update
sudo yum -y install docker


sudo systemctl start docker


sudo docker run -d \
  --name nodejs-demoapp \
  -p 3000:3000 \
  ghcr.io/benc-uk/nodejs-demoapp:latest
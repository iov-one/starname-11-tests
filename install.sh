#!/bin/bash

## apt install
apt-get update
apt-get upgrade
apt-get install -y gcc make git wget nginx

# install Golang
cd 
mkdir tmp_download
cd tmp_download

wget https://go.dev/dl/go1.19.3.linux-amd64.tar.gz 
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile

cd 
rm -fr tmp_download


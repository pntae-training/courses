#!/bin/bash

#install the package
yum install nfs-utils targetcli wget -y
#Create 2GB backend file
dd if=/dev/zero of=/var/tmp/file1.img bs=1M count=2000
dd if=/dev/zero of=/var/tmp/file2.img bs=1M count=2000
#pull the configured targetcli configuration file
wget --output-document=/etc/target/saveconfig.json https://raw.githubusercontent.com/pntae-training/courses/master/tech-breakfix-ha-001/hacluster/tasks/saveconfig.json
#restart target
systemctl restart target
mkdir /nfs
chmod 777 /nfs
echo "/nfs *(rw,sync,no_root_squash)" >> /etc/exports
echo "Test apache" > /nfs/index.html
chmod 644 /nfs/index.html
systemctl start nfs

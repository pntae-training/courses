#!/bin/bash
date >> /tmp/log
echo -e "running run-node-install-sh" >> /tmp/log
cd /root/breakfix1
ansible-playbook node-install.yml >> /tmp/log 2>&1
date >> /tmp/log

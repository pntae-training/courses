#!/bin/bash
date >> /tmp/log
echo -e "running run-node-install-sh" >> /tmp/log
cd /root/breakfix1
ansible-playbook node-install.yml
date >> /tmp/log

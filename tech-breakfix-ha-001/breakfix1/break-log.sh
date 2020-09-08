#!/bin/bash

systemctl stop systemd-journald rsyslog &> /dev/null
rm -rf /run/log/journal/*
rm -rf /var/log/messages
systemctl start systemd-journald rsyslog &> /dev/null
sleep 5

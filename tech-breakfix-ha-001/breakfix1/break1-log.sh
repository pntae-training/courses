#!/bin/bash

systemctl stop systemd-journald rsyslog
rm -rf /run/log/journal/*
rm -rf /var/log/messages
systemctl start systemd-journald rsyslog
sleep 5

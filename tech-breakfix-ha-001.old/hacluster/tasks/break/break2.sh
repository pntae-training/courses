#!/bin/bash
#find the ip address
ip2=`getent hosts nodeb | awk -F" " '{print $1}'`
ip3=`getent hosts nodec | awk -F" " '{print $1}'`

/usr/local/bin/mk qdisc del dev eth0 root
/usr/local/bin/mk qdisc add dev eth0 root handle 1: prio
/usr/local/bin/mk qdisc add dev eth0 root handle 2: prio
/usr/local/bin/mk qdisc add dev eth0 parent 1:3 handle 30: netem delay 1200ms 500ms 25%
/usr/local/bin/mk qdisc add dev eth0 parent 2:3 handle 30: netem delay 1200ms 500ms 25%
/usr/local/bin/mk filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst $ip2/32  flowid 1:3
/usr/local/bin/mk filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst $ip3/32  flowid 2:3
systemctl stop systemd-journald rsyslog
rm -rf /run/log/journal/*
rm -rf /var/log/messages
systemctl start systemd-journald rsyslog
sleep 30
/usr/local/bin/mk qdisc del dev eth0 root
/usr/local/bin/mk qdisc del dev eth0 root  &> /dev/null

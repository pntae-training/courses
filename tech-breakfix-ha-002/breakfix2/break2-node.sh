#!/bin/bash

#!/bin/bash
#find the ip address
ip2=`getent hosts nodeb.example.com | awk -F" " '{print $1}'`
ip3=`getent hosts nodec.example.com | awk -F" " '{print $1}'`

/usr/local/bin/mk qdisc del dev eth0 root &> /dev/null
/usr/local/bin/mk qdisc add dev eth0 root handle 1: prio &> /dev/null
/usr/local/bin/mk qdisc add dev eth0 root handle 2: prio &> /dev/null
/usr/local/bin/mk qdisc add dev eth0 parent 1:3 handle 30: netem delay 1200ms 500ms 25% &> /dev/null
/usr/local/bin/mk qdisc add dev eth0 parent 2:3 handle 30: netem delay 1200ms 500ms 25% &> /dev/null
/usr/local/bin/mk filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst $ip2/32  flowid 1:3 &> /dev/null
/usr/local/bin/mk filter add dev eth0 protocol ip parent 1:0 prio 3 u32 match ip dst $ip3/32  flowid 2:3 &> /dev/null
systemctl stop systemd-journald rsyslog 2>&1 1>/dev/null
rm -rf /run/log/journal/*
rm -rf /var/log/messages
systemctl start systemd-journald rsyslog 2>&1 1>/dev/null
sleep 30
/usr/local/bin/mk qdisc del dev eth0 root &> /dev/null
/usr/local/bin/mk qdisc del dev eth0 root  &> /dev/null

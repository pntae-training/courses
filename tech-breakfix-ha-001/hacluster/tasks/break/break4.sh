#!/bin/bash
#find the ip address
pid1=`pidof corosync`
/usr/bin/taskset -c1 /usr/local/bin/app 5 0.5 &
pid2=`echo $!`
/usr/bin/taskset -c0 /usr/local/bin/app 5 0.5 &
pid3=`echo $!`
sleep 60
chrt -r -p 99 $pid2
chrt -r -p 99 $pid3
chrt -o -p 0 $pid1

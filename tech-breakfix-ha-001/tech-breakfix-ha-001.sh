#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 <pass either break or grade>"
        exit
fi

case "$1" in

break)  echo "Breaking the node"
        ssh nodea.example.com sudo /usr/local/bin/break-node.sh
        ssh nodea.example.com sudo /usr/local/bin/break-log.sh
        ssh nodeb.example.com sudo /usr/local/bin/break-log.sh
        ;;

grade)  echo "Grading Breakfix 1\n"
        echo "Node A has to be reachable\n"
        ssh nodea.example.com sudo pcs constraint location remove location-web-nodea.example.com-INFINITY &> /dev/null
        sleep 5
        ssh nodea.example.com sudo pcs resource move web nodeb.example.com 2>&1 1>/dev/null &> /dev/null
        sleep 15
        output1=`curl http://nodeb/index.html 2>&1 |grep "Test apache"| wc -l`
        ssh nodea.example.com sudo pcs resource move web nodec.example.com 2>&1 1>/dev/null &> /dev/null
        sleep 15
        output2=`curl http://nodec/index.html 2>&1 |grep "Test apache"| wc -l`
        ssh nodea.example.com sudo pcs resource move web nodea.example.com 2>&1 1>/dev/null &> /dev/null
        sleep 15
        output3=`curl http://nodea/index.html 2>&1 |grep "Test apache"| wc -l`
        output7=`ssh nodea.example.com sudo pcs constraint show |grep "web with clusterfs-clone"| wc -l`
        if [ "$output1" = "1" ] && [ "$output2" = "1" ] && [ "$output3" = "1" ] && [ "$output7" = "1" ] ; then
          output4=FIRST
        fi
        if [ `ssh nodea.example.com sudo gfs2_edit -p journals /dev/webfs_vg/webfs_lv |grep journal | wc -l` = 3 ]; then
          output5=SECOND
        fi
        if [ `ssh nodea.example.com sudo pcs resource show |grep -A1 clusterfs-clone |grep Started | awk -F":" '{print $2}' | awk -F" " '{printf "%s\n %s\n %s\n", $2,$3,$4}' | wc -l` = 3 ]; then
          output6=THIRD
        fi
        if [ "$output4" = "FIRST" ] && [ "$output5" = "SECOND" ] && [ "$output6" = "THIRD" ]; then
          echo "CODE: PROCEEDTOSECONDBREAKFIX"
        else
          echo "CODE: FAIL"
        fi
        ;;
esac

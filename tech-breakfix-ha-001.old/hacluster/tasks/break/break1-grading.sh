#!/bin/bash


#move the service to nodeb

pcs constraint location remove location-web-nodea-INFINITY &> /dev/null
sleep 5
pcs resource move web nodeb 2>&1 1>/dev/null &> /dev/null
sleep 15
output1=`curl http://nodeb/index.html 2>&1 |grep "Test apache"| wc -l`

pcs resource move web nodec 2>&1 1>/dev/null &> /dev/null
sleep 15
output2=`curl http://nodec/index.html 2>&1 |grep "Test apache"| wc -l`

pcs resource move web nodea 2>&1 1>/dev/null &> /dev/null
sleep 15

output3=`curl http://nodea/index.html 2>&1 |grep "Test apache"| wc -l`

output7=`pcs constraint show |grep "clusterfs-clone then start web"| wc -l`

if [ "$output1" = "1" ] && [ "$output2" = "1" ] && [ "$output3" = "1" ] && [ "$output7" = "1" ] ; then
    output4=FIRST
fi

if [ `gfs2_edit -p journals /dev/webfs_vg/webfs_lv |grep journal | wc -l` = 3 ]; then
    output5=SECOND
fi

if [ `pcs resource show |grep -A1 clusterfs-clone |grep Started | awk -F":" '{print $2}' | awk -F" " '{printf "%s\n %s\n %s\n", $2,$3,$4}' | wc -l` = 3 ]; then
    output6=THIRD
fi

if [ "$output4" = "FIRST" ] && [ "$output5" = "SECOND" ] && [ "$output6" = "THIRD" ]; then
    echo "CODE: PROCEEDTOSECONDBREAKFIX"
else
    echo "CODE: FAIL"
fi

#!/bin/bash

if [ $# -lt 1 ]
then
        echo "Usage : $0 <pass either break or grade>"
        exit
fi

case "$1" in

break)  echo "Breaking the node"
        ssh  -n -f nodea.example.com sudo nohup /usr/local/bin/break2-node.sh 1>/dev/null 2>&1
        echo "Check your server logs and observe the messages"
        ;;
   
grade)  echo "Grading Breakfix 2. Node A has to be reachable"

        output=`ssh nodea.example.com sudo corosync-cmapctl | grep "totem.token" | grep -v "runtime.config" | wc -l`
        if [ $output == 1 ]; then
           echo "CODE: TRYOUTBREAKMEFIX3"
        else
           echo "CODE:  TRY AGAIN"
        fi
esac

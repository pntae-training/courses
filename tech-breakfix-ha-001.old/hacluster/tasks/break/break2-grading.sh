#!/bin/bash

output=`corosync-cmapctl | grep "totem.token" | grep -v "runtime.config" | wc -l`
if [ $output == 1 ]; then
   echo "CODE: TRYOUTBREAKMEFIX3"
else
   echo "CODE:  TRY AGAIN"
fi

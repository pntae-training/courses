#!/bin/bash

if [ `pcs status |grep "mariadb-fs-res" |grep Started|wc -l` = 1 ]; then
   output1=FIRST
fi
if [ `pcs status |grep "mariadb-server-res" |grep Started|wc -l` = 1 ]; then
   output2=SECOND
fi

if [ "$output1" = "FIRST" ] && [ "$output2" = "SECOND" ]; then
   echo "FRACKEDBREAK5"
else
   echo "TRY AGAIN"
fi

#!/bin/bash

output=`pcs constraint --full |grep "start dlm-clone then start clvmd-clone" | wc -l`
if [ $output == 1 ]; then
   echo "CODE: TRY4thREAKYOUFIX4"
else
   echo "CODE: TRY AGAIN"
fi

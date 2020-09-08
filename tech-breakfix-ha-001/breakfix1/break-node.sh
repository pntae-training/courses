#!/bin/bash

pcs resource disable web &> /dev/null
pcs resource disable clusterfs --wait=15 &> /dev/null
mkfs.gfs2 -j2 -p lock_dlm -O -t clusterhatroubleshooting:clusterfs /dev/webfs_vg/webfs_lv &> /dev/null
pcs resource enable clusterfs &> /dev/null
chcon -t httpd_log_t /var/log/httpd &> /dev/null
pcs resource enable web &> /dev/null
pcs constraint remove order-clusterfs-clone-web-mandatory &> /dev/null
sleep 10
pcs resource cleanup &> /dev/null

#!/bin/bash
pcs resource disable web
pcs resource disable clusterfs --wait=15
mkfs.gfs2 -j2 -p lock_dlm -O -t clusterhatroubleshooting:clusterfs /dev/webfs_vg/webfs_lv
pcs resource enable clusterfs
chcon -t httpd_log_t /var/log/httpd
pcs resource enable web
pcs constraint remove order-clusterfs-clone-web-mandatory
sleep 30
pcs resource cleanup

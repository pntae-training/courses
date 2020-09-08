#!/bin/bash
pcs resource disable web
pcs resource disable clusterfs --wait=15
mkfs.gfs2 -j3 -p lock_dlm -O -t clusterhatroubleshooting:clusterfs /dev/webfs_vg/webfs_lv
pcs resource enable clusterfs
pcs resource enable web
pcs constraint order start clusterfs-clone then web
sleep 10
pcs resource cleanup

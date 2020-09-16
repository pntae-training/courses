for vm in nodea.example.com nodeb.example.com nodec.example.com
do
	ssh $vm	"sudo yum install pcs fence-agents-all lvm2-cluster gfs2-utils iscsi-initiator-utils httpd sysstat mariadb mariadb-server tcpdump wget sysstat  bzip2"

	ssh $vm "sudo wget https://raw.githubusercontent.com/pntae-training/courses/master/tech-breakfix-ha-001/breakfix1/mk -P /usr/local/bin/"
	ssh $vm "sudo chmod 0755 /usr/local/bin/mk"

	ssh $vm "sudo wget https://raw.githubusercontent.com/pntae-training/courses/master/tech-breakfix-ha-001/breakfix1/my.cnf -P /etc/"

	ssh $vm "sudo wget https://raw.githubusercontent.com/pntae-training/courses/master/tech-breakfix-ha-001/breakfix1/httpd.conf -P /etc/httpd/conf/"

	ssh $vm "sudo echo redhat | passwd hacluster --stdin"

	ssh $vm "sudo systemctl enable pcsd"
	ssh $vm "sudo systemctl start pcsd"
done

ssh nodea.example.com "sudo sed -i 's/^InitiatorName=.*/InitiatorName=iqn.2020-07.com.redhat:srv1/' /etc/iscsi/initiatorname.iscsi"

ssh nodeb.example.com "sudo sed -i 's/^InitiatorName=.*/InitiatorName=iqn.2020-07.com.redhat:srv2/' /etc/iscsi/initiatorname.iscsi"

ssh nodec.example.com "sudo sed -i 's/^InitiatorName=.*/InitiatorName=iqn.2020-07.com.redhat:srv3/' /etc/iscsi/initiatorname.iscsi"


for vm in nodea.example.com nodeb.example.com nodec.example.com
do

	ssh $vm "sudo systemctl enable iscsid"
	ssh $vm "sudo systemctl start iscsid"

	ssh $vm "sudo systemctl enable iscsi"
	ssh $vm "sudo systemctl start iscsi"

        ssh $vm "sudo /sbin/iscsiadm --mode discovery --type sendtargets --portal frontend:3260"

        ssh $vm "sudo /sbin/iscsiadm --mode node --targetname iqn.2020-01.local.rhce.halvm:target --portal frontend:3260 --login"

        ssh $vm "sudo /sbin/iscsiadm --mode node --targetname iqn.2020-01.local.rhce.ipa:target --portal frontend:3260 --login"
done

ssh nodea.example.com "sudo pcs cluster auth nodea.example.com nodeb.example.com nodec.example.com -u hacluster -p redhat --force"

ssh nodea.example.com "sudo pcs cluster setup --start --enable --name clusterhatroubleshooting nodea.example.com nodeb.example.com nodec.example.com --force"

ssh nodea.example.com "sudo pcs property set no-quorum-policy=freeze"

ssh nodea.example.com "sudo pcs stonith create fence_node1 fence_ipmilan pcmk_host_list="nodea.example.com" ipaddr="192.168.47.220" login="admin" passwd="redhat" lanplus=1  power_wait=4; pcs stonith create fence_node2 fence_ipmilan pcmk_host_list="nodeb.example.com" ipaddr="192.168.47.221" login="admin" passwd="redhat" lanplus=1  power_wait=4; pcs stonith create fence_node3 fence_ipmilan pcmk_host_list="nodec.example.com" ipaddr="192.168.47.222" login="admin" passwd="redhat" lanplus=1  power_wait=4"

ssh nodea.example.com "sudo pcs constraint location fence_node1 prefers nodea.example.com; pcs constraint location fence_node2 prefers nodeb.example.com; pcs constraint location fence_node3 prefers nodec.example.com"

ssh nodea.example.com "sudo pcs resource create dlm ocf:pacemaker:controld op monitor interval=30s on-fail=fence clone interleave=true ordered=true"

ssh nodea.example.com "sudo /sbin/lvmconf --enable-cluster; systemctl disable lvm2-lvmetad --now"

ssh nodeb.example.com "sudo /sbin/lvmconf --enable-cluster; systemctl disable lvm2-lvmetad --now"

ssh nodec.example.com "sudo /sbin/lvmconf --enable-cluster; systemctl disable lvm2-lvmetad --now"

ssh nodea.example.com "sudo pcs resource create clvmd ocf:heartbeat:clvm op monitor interval=30s on-fail=fence clone interleave=true ordered=true"

ssh nodea.example.com "sudo pcs constraint order start dlm-clone then clvmd-clone"

ssh nodea.example.com "sudo pcs constraint colocation add clvmd-clone with dlm-clone"

ssh nodea.example.com "sudo wipefs --all --force /dev/sda"

ssh nodea.example.com "sudo wipefs --all --force /dev/sdb"

ssh nodea.example.com "sudo pvcreate /dev/sda -ff -y; sleep 5"

ssh nodea.example.com "sudo vgcreate -Ay -cy --shared webfs_vg /dev/sda; sleep 10"
  
ssh nodea.example.com "sudo lvcreate -L1.3G -n webfs_lv webfs_vg -y --config 'global { locking_type = 0 }'"


for vm in nodea.example.com nodeb.example.com nodec.example.com
do
	ssh $vm "sudo lvchange -ay /dev/webfs_vg/webfs_lv"
done

ssh nodea.example.com "sudo mkfs.gfs2 -j3 -p lock_dlm -O -t clusterhatroubleshooting:clusterfs /dev/webfs_vg/webfs_lv"
ssh nodea.example.com "sudo pcs resource create web_vip ocf:heartbeat:IPaddr2 ip=192.168.47.225 cidr_netmask=24 op monitor interval=30s --group web"
ssh nodea.example.com "sudo pcs resource create webnfs ocf:heartbeat:Filesystem device="frontend:/nfs" directory="/var/www/html" fstype="nfs" --group web"

ssh nodea.example.com "sudo pcs resource create clusterfs Filesystem device="/dev/webfs_vg/webfs_lv" directory="/var/log/httpd" fstype="gfs2" options="noatime" op monitor interval=10s on-fail=fence clone interleave=true"

ssh nodea.example.com "sudo pcs constraint order start clvmd-clone then clusterfs-clone;pcs constraint colocation add clusterfs-clone with clvmd-clone"

ssh nodea.example.com "sudo pcs resource create apache_res apache configfile="/etc/httpd/conf/httpd.conf" statusurl="http://127.0.0.1/server-status" --group web"

ssh nodea.example.com "sudo pcs constraint order start clusterfs-clone then web;  pcs constraint location web prefers nodea.example.com"

for vm in nodea.example.com nodeb.example.com nodec.example.com
do
	#typereset.sh script is implemented below
	ssh $vm "sudo chcon -R -t httpd_log_t /var/log/httpd"
done

ssh nodea.example.com "sudo pcs resource cleanup"


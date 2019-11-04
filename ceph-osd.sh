# uninstall

systemctl stop      ceph-osd@*
rm -f /etc/systemd/system/ceph-osd.target.wants/ceph-osd@*.service

umount      $(mount  | sed -n 's|^tmpfs on \(/var/lib/ceph/osd/.*\) type .*$|\1|p')
lvremove -f $(lvdisplay | sed -n 's/^[[:space:]]*LV Path[[:space:]]\+\(.*\)$/\1/p')

apt-get purge       -y  lvm2*   &&  \
apt-get purge       -y  ceph-*  &&  \
apt-get remove      -y  rbd-nbd &&  \
apt-get autoremove  -y

rm -rf      /run/ceph       /var/lib/ceph   /etc/lvm            \
            /etc/systemd/system/multi-user.target.wants/ceph*   \
            /etc/systemd/system/ceph-osd.target.wants/          \
            /run/systemd/system/ceph-osd.target.wants

# install
apt-get update              &&  \
apt-get upgrade     -y      &&  \
apt-get install     -y          \
                    ceph-common \
                    ceph-osd    \
                    lvm2        \
                    rbd-nbd     \
                            &&  \
apt-get autoremove  -y

(cd /home/fanarie ; mv ceph.conf ceph.client.admin.keyring /etc/ceph)
chown   ceph:ceph   /etc/ceph/*

(cd /home/fanarie ; mv ceph.keyring     /var/lib/ceph/bootstrap-osd)

wipefs  -a  /dev/sda
dd if=/dev/zero of=/dev/sda bs=1M bs=446 count=1
sfdisk      /dev/sda    <<< "2048,,,"

lv=/dev/sda1

ceph-volume lvm prepare --data ${lv}

ceph-volume lvm list

ID=$(  ceph-volume lvm list | sed -n "s/^[[:space:]]\+osd id[[:space:]]\+\([0-9]\+\)$/\1/p")
FSID=$(ceph-volume lvm list | sed -n "s/^[[:space:]]\+osd fsid[[:space:]]\+\([0-9a-f-]\+\)$/\1/p")

ceph-volume lvm activate ${ID} ${FSID}

systemctl restart ceph-osd@${ID}

systemctl enable ceph-osd@${ID}

systemctl status ceph-osd@${ID}

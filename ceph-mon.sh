# uninstall

systemctl   stop    ceph-mgr@$(hostname)
systemctl   stop    ceph-mon@$(hostname)
systemctl   stop    ceph-mds@$(hostname)
systemctl   disable ceph-mgr@$(hostname)
systemctl   disable ceph-mon@$(hostname)
systemctl   disable ceph-mds@$(hostname)

apt-get     purge       -y  ceph-*  &&  \
apt-get     remove      -y  rbd-nbd &&  \
apt-get     autoremove  -y

rm -rf      /run/ceph       \
            /var/lib/ceph

# install
apt-get update              &&  \
apt-get upgrade -y          &&  \
apt-get install -y              \
                    ceph-common \
                    ceph-mon    \
                    ceph-mgr    \
                    ceph-mds    \
                    rbd-nbd     \
                            &&  \
apt-get autoremove  -y


uuid=$(uuidgen)
nom_name="$(hostname)"
nom_ip="192.168.1.21"
nom_mask="192.168.1.0/24"
cluster="ceph"

cat > /etc/ceph/ceph.conf << EOF
[global]
fsid                    = ${uuid}

mon allow pool delete   = true
mon initial members     = ${nom_name}
mon host                = ${nom_ip}
public network          = ${nom_mask}

auth cluster required   = cephx
auth service required   = cephx
auth client required    = cephx

osd journal size            = 1024
osd pool default size       = 2
osd pool default min size   = 1
osd pool default pg num     = 128
osd pool default pgp num    = 128
osd crush chooseleaf type   = 1

EOF

chown ceph:ceph /etc/ceph/ceph.conf

ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
chown ceph:ceph /tmp/ceph.mon.keyring

ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'

ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring

monmaptool --create --add ${nom_name} ${nom_ip} --fsid ${uuid} /tmp/monmap

mkdir --mode=755 /var/lib/ceph/mon/${cluster}-${nom_name}   ; chown -R ceph:ceph /var/lib/ceph/mon/${cluster}-${nom_name}

sudo -u ceph ceph-mon --cluster ${cluster} --mkfs -i ${nom_name} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
echo "CLUSTER=${cluster}" >> /etc/default/ceph

systemctl start ceph-mon@${nom_name}

mkdir --mode=755 /var/lib/ceph/mgr/${cluster}-${nom_name}   ; chown -R ceph:ceph /var/lib/ceph/mgr/${cluster}-${nom_name}

ceph auth get-or-create mgr.${nom_name} mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/${cluster}-${nom_name}/keyring
chown ceph:ceph /var/lib/ceph/mgr/${cluster}-${nom_name}/keyring

systemctl start ceph-mgr@${nom_name}

mkdir --mode=755 /var/lib/ceph/mds/${cluster}-${nom_name}   ; chown -R ceph:ceph /var/lib/ceph/mds/${cluster}-${nom_name}

ceph-authtool --create-keyring /var/lib/ceph/mds/${cluster}-${nom_name}/keyring --gen-key -n mds.${nom_name}
ceph auth add mds.${nom_name} osd "allow rwx" mds "allow" mon "allow profile mds" -i /var/lib/ceph/mds/${cluster}-${nom_name}/keyring

sed -i "s/--setuser ceph --setgroup ceph/--setuser ceph --setgroup ceph -m %i:6789/" /lib/systemd/system/ceph-mds@.service

systemctl daemon-reload
systemctl start ceph-mds@${nom_name}

systemctl enable ceph-mon@${nom_name}
systemctl enable ceph-mgr@${nom_name}
systemctl enable ceph-mds@${nom_name}

rm -f /tmp/monmap /tmp/ceph.mon.keyring

systemctl restart ceph-mon@${nom_name}
systemctl restart ceph-mgr@${nom_name}
systemctl restart ceph-mds@${nom_name}

ceph status

systemctl status ceph-mon@${nom_name}
systemctl status ceph-mgr@${nom_name}
systemctl status ceph-mds@${nom_name}

scp /etc/ceph/ceph.conf                         \
    /etc/ceph/ceph.client.admin.keyring         \
    /var/lib/ceph/bootstrap-osd/ceph.keyring    \
    fanarie@k8s-worker-1.yggdrasil.local:~


scp /etc/ceph/ceph.conf                         \
    /etc/ceph/ceph.client.admin.keyring         \
    /var/lib/ceph/bootstrap-osd/ceph.keyring    \
    fanarie@k8s-worker-2.yggdrasil.local:~

#Less than 5 OSDs set pg_num to 128
#Between 5 and 10 OSDs set pg_num to 512
#Between 10 and 50 OSDs set pg_num to 4096

ceph    osd pool    delete              kube kube --yes-i-really-really-mean-it
ceph    osd pool    create              kube 128
ceph    osd pool    application enable  kube rbd
ceph   auth get-or-create client.kube mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=kube' -o /etc/ceph/ceph.client.kube.keyring


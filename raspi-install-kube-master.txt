
sudo su -
passwd root

if ! ( cat /boot/cmdline.txt | tr -s ' ' '\n'  | grep -qq ipv6.disable=1        ); then cp -f /boot/cmdline.txt /boot/cmdline.txt.tmp ; (cat /boot/cmdline.txt.tmp | tr -s ' ' '\n' | sed '$a ipv6.disable=1'       | tr -s '\n' ' ' ; echo -en '\n') > /boot/cmdline.txt ; rm -f /boot/cmdline.txt.tmp ;fi
if ! ( cat /boot/cmdline.txt | tr -s ' ' '\n'  | grep -qq cgroup_enable=cpuset  ); then cp -f /boot/cmdline.txt /boot/cmdline.txt.tmp ; (cat /boot/cmdline.txt.tmp | tr -s ' ' '\n' | sed '$a cgroup_enable=cpuset' | tr -s '\n' ' ' ; echo -en '\n') > /boot/cmdline.txt ; rm -f /boot/cmdline.txt.tmp ;fi
if ! ( cat /boot/cmdline.txt | tr -s ' ' '\n'  | grep -qq cgroup_memory=1       ); then cp -f /boot/cmdline.txt /boot/cmdline.txt.tmp ; (cat /boot/cmdline.txt.tmp | tr -s ' ' '\n' | sed '$a cgroup_memory=1'      | tr -s '\n' ' ' ; echo -en '\n') > /boot/cmdline.txt ; rm -f /boot/cmdline.txt.tmp ;fi
if ! ( cat /boot/cmdline.txt | tr -s ' ' '\n'  | grep -qq cgroup_enable=memory  ); then cp -f /boot/cmdline.txt /boot/cmdline.txt.tmp ; (cat /boot/cmdline.txt.tmp | tr -s ' ' '\n' | sed '$a cgroup_enable=memory' | tr -s '\n' ' ' ; echo -en '\n') > /boot/cmdline.txt ; rm -f /boot/cmdline.txt.tmp ;fi

if ! ( grep -qq 'dtoverlay=disable-wifi'    /boot/config.txt); then 
    echo "dtoverlay=disable-wifi"       >>  /boot/config.txt
fi
if ! ( grep -qq 'dtoverlay=disable-bt'      /boot/config.txt); then 
    echo "dtoverlay=disable-bt"         >>  /boot/config.txt
fi

systemctl  stop    hciuart.service
systemctl  disable hciuart.service
systemctl  stop    wpa_supplicant.service
systemctl  disable wpa_supplicant.service
systemctl  stop    bluetooth.service
systemctl  disable bluetooth.service

apt-get update
apt-get upgrade -y

apt-get install vim htop tree dnsutils -y

apt-get autoremove  -y

timedatectl set-timezone 'Europe/Paris'

echo ''             >> .bashrc
echo 'export PS1="\[\033[38;5;1m\]\u@\h:\[$(tput sgr0)\]\[\033[38;5;27m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"' >> ~/.bashrc

sed -i 's/# alias ls=/alias ls=/'   ~/.bashrc
sed -i 's/# alias ll=/alias ll=/'   ~/.bashrc
sed -i 's/# alias l=/alias  l=/'    ~/.bashrc


echo 'set mouse-=a' > ~/.vimrc

hostnamectl set-hostname k8s-master

sed -i '/^::1[[:space:]]/d'                                         /etc/hosts
sed -i '/^ff02::1[[:space:]]/d'                                     /etc/hosts
sed -i '/^ff02::2[[:space:]]/d'                                     /etc/hosts
sed -i '/raspberrypi/d'                                             /etc/hosts
echo "127.0.1.1       k8s-master"                               >>  /etc/hosts
echo "192.168.1.21    k8s-master"                               >>  /etc/hosts

echo ''                                             >> /etc/dhcpcd.conf
echo 'interface eth0'                               >> /etc/dhcpcd.conf
echo 'static    ip_address=192.168.1.21'            >> /etc/dhcpcd.conf
echo 'static    routers=192.168.1.1'                >> /etc/dhcpcd.conf
echo 'static    domain_name_servers=192.168.1.254'  >> /etc/dhcpcd.conf

echo ''                             >>  /home/pi/.bashrc
echo 'alias ls="ls $LS_OPTIONS"'    >>  /home/pi/.bashrc
echo 'alias ll="ls $LS_OPTIONS -l"' >>  /home/pi/.bashrc
echo 'alias  l="ls $LS_OPTIONS -lA"'>>  /home/pi/.bashrc
echo ''                             >>  /home/pi/.bashrc
echo 'PS1="\[\033[38;5;22m\]\u@\h:\[$(tput sgr0)\]\[\033[38;5;3m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]\n\\$ \[$(tput sgr0)\]"'                           >>  /home/pi/.bashrc
echo 'set mouse-=a' > /home/pi/.vimrc
chown pi:pi           /home/fanarie/.vimrc

passwd -l pi

( cd /tmp ; unzip -o /home/pi/vl805_update_0137ab.zip   )
( cd /tmp ; chmod +x vl805                              )
( cd /tmp ; ./vl805 -w vl805_fw_0137ab.bin              )

reboot

su -
curl -sSL https://get.docker.com | sh
usermod -aG docker pi

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "max-concurrent-uploads": 1,
  "storage-driver": "overlay2"
}
EOF
systemctl restart docker

dphys-swapfile swapoff
dphys-swapfile uninstall
systemctl disable dphys-swapfile
update-rc.d    dphys-swapfile remove

swapoff -a
sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.ipv4.ip_forward=1
apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb [arch=armhf] https://packages.cloud.google.com/apt/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
apt-get update


apt-get install kubelet kubeadm kubectl kubernetes-cni  -y

apt-get autoremove  -y

kubeadm config images pull

### Weave ###################
kubeadm init --apiserver-advertise-address=192.168.1.21
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f kube-flannel.yml
systemctl restart kubelet
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.WEAVE_MTU=8912"

### flannel #################
kubeadm init  --apiserver-advertise-address=192.168.1.21 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f kube-flannel.yml
systemctl restart kubelet
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#kubectl label node k8s-node-1 node-role.kubernetes.io/worker=worker

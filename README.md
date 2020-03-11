
See [armhf](https://github.com/frederic-blanc/rpi-k8s/tree/armhf) branch for the raspbian:buster 32bits deployment<br/>
[master](https://github.com/frederic-blanc/rpi-k8s) branch is working in progress for an arm64 version.

# use arm64 ubuntu 18.04 LTS
The 64bits image can be found here: https://ubuntu.com/download/raspberry-pi
I prefer the 18.04 LTS version, instead of the latest one, which support ends in june 2020

To manage a ip defined and ubuntu account no expired, as well as a non update kernel at boot (this will be managed by the ansible install), I use cloud-init. Template files can be found in the cloud-init folder and it must copied in the /boot partition just after the image burn. Just Change your targeted IP address in the network-config file.

For the moment only the prepare-k8s-cluster has been updated to work on this new arm64 ubuntu.

Use Calico as networkplugin this time:
https://docs.projectcalico.org/getting-started/kubernetes/quickstart
* create /etc/NetworkManager/conf.d/calico.conf to prevent NetworkManager from interfering with the interfaces:
```
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
```
* set sysctl -w net.netfilter.nf_conntrack_max=1000000
  echo "net.netfilter.nf_conntrack_max=1000000" >> /etc/sysctl.conf

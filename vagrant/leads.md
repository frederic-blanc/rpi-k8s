# Calico does not work with iptables >= 1.8
**Src.:** https://github.com/projectcalico/calico/issues/2322

**issue:** on debian/buster

**to test:** 
>update-alternatives --set iptables /usr/sbin/iptables-legacy



# missing iptables rules

**Src.:** https://github.com/projectcalico/canal/issues/31

**issue:** for flannel

**to test:**
>iptables -A FORWARD -o flannel.1 -j ACCEPT

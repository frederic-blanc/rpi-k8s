# Calico does not work with iptables >= 1.8
**Src.:** https://github.com/projectcalico/calico/issues/2322

**issue:** on debian/buster

**to test:** 
>update-alternatives --set iptables /usr/sbin/iptables-legacy

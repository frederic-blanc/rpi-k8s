# rpi-k8S

vagrant file only for debbuging network plugin

# to do
- roles: prepare os
  - update and upgrade
  - useful tools
  - disable pi account
  - add password to root
  - create new user
  - define .bashrc and .vimrc
  - disable ipv6, blutooth and wifi
  
- define cmdline.txt parameters for docker
  - cgroup_enable=cpuset
  - cgroup_enable=memory
  - cgroup_memory=1
  - swapaccount=1  # to be checked
- use own certificate authorities:  kubeadm xxxx --cert-dir /etc/kubernetes/pki
  - define /etc/kubernetes/pki/ca.crt and /etc/kubernetes/pki/ca.key
  
- install kubernetes dashboard UI







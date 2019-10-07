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
  - kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
  - kubectl -n kube-system edit service kubernetes-dashboard
    - ClusterIP => NodePort
  - create admin-user.yaml
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: admin-user
    namespace: kube-system
  ```
  - create  admin-role.yaml
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: ClusterRoleBinding
  metadata:
    name: admin-user
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kube-system
  ```
  - kubectl apply -f admin-user.yaml
  - kubectl apply -f admin-role.yaml





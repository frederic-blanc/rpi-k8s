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
  - ip=192.168.0.10
  - ipv6.disable=1
  - swapaccount=1  # see https://unix.stackexchange.com/questions/531480/what-does-swapaccount-1-in-grub-cmdline-linux-default-do#answer-531489
- use own certificate authorities:  kubeadm xxxx --cert-dir /etc/kubernetes/pki
  - define /etc/kubernetes/pki/ca.crt and /etc/kubernetes/pki/ca.key
  
- install kubernetes dashboard UI
  - kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
  - create kubernetes-dashboard-ext.yml file
    ```yaml
    ---
    kind: Service
    apiVersion: v1
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
      name: kubernetes-dashboard
      namespace: kubernetes-dashboard
    spec:
      ports:
        - port: 443
          targetPort: 8443
          nodePort: 32000
      type: NodePort
      selector:
        k8s-app: kubernetes-dashboard
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: admin-user
      namespace: kubernetes-dashboard
    ---
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
      namespace: kubernetes-dashboard
    ```
  - kubectl apply -f kubernetes-dashboard-ext.yml
  - generate secret
  ```kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')```




# rpi-k8S

vagrant file only for debbuging network plugin

# to do
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
    ```bash
    kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
    ```

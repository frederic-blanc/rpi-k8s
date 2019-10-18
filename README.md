# rpi-k8S

vagrant file provided for debbuging network plugin on debian

# to do  
- issue with weave v2.5.2 (see https://github.com/weaveworks/weave/issues/3717),
  flannel just works fine
  
- <s>deploy traefik ingress:</s>
  - <s>https://github.com/containous/traefik</s>
  - <s>https://medium.com/@dusansusic/traefik-ingress-controller-for-k8s-c1137c9c05c4</s>
  - <s>https://github.com/dusansusic/kubernetes-traefik/blob/master/README.md</s>
  - <s>https://blog.nobugware.com/post/2019/traefik-2-0-with-kubernetes/</s>
  - <s>https://gist.github.com/akhenakh</s>

- fallback to nginx-ingress-controller
  - image exists for ARM arch (https://quay.io/repository/kubernetes-ingress-controller/nginx-ingress-controller-arm), 
    just need to update the deployment file (https://github.com/kubernetes/ingress-nginx/blob/master/deploy/static/mandatory.yaml)
  - https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
  - https://github.com/kubernetes/ingress-nginx/issues/3762
  - https://kubernetes.github.io/ingress-nginx/examples/rewrite/#rewrite-target
  ```yaml
  ---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: whoami-deployment
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: whoami
    template:
      metadata:
        labels:
          app: whoami
      spec:
        containers:
        - name: whoami-container
          image: containous/whoami
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: whoami-service
  spec:
    ports:
    - name: http
      targetPort: 80
      port: 80
    selector:
      app: whoami
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: whoami-ingress
    annotations:
      kubernetes.io/ingress.class: nginx
  spec:
    rules:
    - http:
        paths:
          - path: /whoami
            backend:
              serviceName: whoami-service
              servicePort: 80
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: ingress-nginx
    namespace: ingress-nginx
    labels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/part-of: ingress-nginx
  spec:
    type: NodePort
    ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
    externalIPs:
    - 192.168.1.21
    selector:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/part-of: ingress-nginx
    ```

- install ceph to serve distributed FS
  - https://www.jamescoyle.net/how-to/2105-small-scale-ceph-replicated-storage
  - https://bryanapperson.com/blog/the-definitive-guide-ceph-cluster-on-raspberry-pi/
  - http://howtolamp.com/projects/ceph.pdf
  - https://docs.ceph.com/docs/master/install/manual-deployment/#monitor-bootstrapping
  



 



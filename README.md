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

- install ceph to serve distributed FS
  - https://www.jamescoyle.net/how-to/2105-small-scale-ceph-replicated-storage
  - http://howtolamp.com/projects/ceph.pdf

  

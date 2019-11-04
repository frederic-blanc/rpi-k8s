# to do  
- issue with *weave* ~~v2.5.2~~ (see https://github.com/weaveworks/weave/issues/3717)<br/>
  Cause by an error in the current rpi-kernel 4.19.75-v7l+, it tricks docker and made it pull an incorrect image arch version (at least not the armhf one)<br/>
  Fix in kernel 4.19.79-v7l+, but it might take a few days to be published/mainlined by the Raspberry Pi Foundation, so that everyone will be able to fix things by running...
  ```bash
  apt update && apt -y dist-upgrade && reboot
  ```
  *flannel* just works fine because it provide all the ARCHs in its ConfigMap installation
  
- add ceph ansible cluster installation 
- deploy ceph-\*-provisioner to allocate persistent filesystem

# use arm64 ubuntu 19.10 image
- https://ubuntu.com/blog/roadmap-for-official-support-for-the-raspberry-pi-4<br/>
  pending USB kernel bug patch

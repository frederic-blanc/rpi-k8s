# to do  
- issue with *weave* v2.5.2 (see https://github.com/weaveworks/weave/issues/3717),
  Cause by an error in the current rpi-kernel 4.19.75-v7l+, that trick docker and it does not pull the correct image (not the armhf one)
  Fix in kernel 4.19.79-v7l+, but it might take a few days to be published/mainlined by the Raspberry Pi Foundation, so that everyone will be able to fix things by running...
  ```bash
  apt update && apt -y dist-upgrade && reboot
  ```
  *flannel* just works fine because it provide all the ARCHs in its ConfigMap installation


See [armhf](https://github.com/frederic-blanc/rpi-k8s/tree/armhf) branch for the raspbian:buster 32bits deployment<br/>

[arm64](https://github.com/frederic-blanc/rpi-k8s) branch is for the ubuntu:18.04 64 bits deployment<br/>

# use arm64 ubuntu 18.04 LTS
The 64bits image can be found here: https://ubuntu.com/download/raspberry-pi

I prefer the 18.04 LTS version, instead of the latest one, which support ends in june 2020

To manage to set ip definition and ubuntu account to no expired, as well as a non update kernel at boot (this will be managed by the ansible install), through the use of cloud-init. 

Template files can be found in the cloud-init folder and it must copied in the /boot partition just after the image burn. Just Change your targeted IP address in the network-config file.

# use arm64 ubuntu 20.04 LTS

The 64bits image can be found here: https://ubuntu.com/download/raspberry-pi

I use the [20.04 LTS version](http://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04-preinstalled-server-arm64+raspi.img.xz).

To manage ip setting and an ubuntu account not expired (as well as a non update kernel at boot first, this will be managed by the ansible install), we use cloud-init files. 

Template files can be found in the cloud-init folder and it must copied in the /boot partition just after the image burn. Just Change your targeted IP address in the network-config file.



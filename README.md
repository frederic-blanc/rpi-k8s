# Use arm64 ubuntu 18.04 LTS
The 64bits image can be found here: https://ubuntu.com/download/raspberry-pi

I prefer the 18.04 LTS version, instead of the latest one, which support ends in june 2020

To manage ip setting and an ubuntu account not expired (as well as a non update kernel at boot first, this will be managed by the ansible install), we use cloud-init files. 

Template files can be found in the cloud-init folder and it must copied in the /boot partition just after the image burn. Just Change your targeted IP address in the network-config file.



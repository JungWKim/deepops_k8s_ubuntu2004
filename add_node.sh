#-----------------------------------
#
# do not run this script as root
#
#-----------------------------------

#!/bin/bash

# basic setup
sudo sed -i 's/1/0/g' /etc/apt/apt.conf.d/20auto-upgrades

# disable ufw
sudo systemctl stop ufw
sudo systemctl disable ufw

# install basic packages
sudo apt update
sudo apt install -y python3-pip net-tools nfs-common whois xfsprogs

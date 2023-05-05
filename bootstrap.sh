#-----------------------------------
#
# do not run this script as root
#
#-----------------------------------

#!/bin/bash

IP=

# basic setup
sudo sed -i 's/1/0/g' /etc/apt/apt.conf.d/20auto-upgrades

# disable ufw
sudo systemctl stop ufw
sudo systemctl disable ufw

# ssh configuration
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa ${USER}@${IP}

# install basic packages
sudo apt update
sudo apt install -y python3-pip net-tools nfs-common whois xfsprogs

# download deepops repository
git clone https://github.com/NVIDIA/deepops.git -b release-22.04
cd deepops

# Install software prerequisites and copy default configuration
# this will create collections and config directory under deepops directory
# kubespray submodules are located under deepops/submodules/kubespray
./scripts/setup.sh

# to use ansible, run below command
source /opt/deepops/env/bin/activate

# edit the inventory
#config/inventory

# edit configuration parametes
#config/group_vars/*.yml

# enable kubectl & kubeadm auto-completion
echo "source <(kubectl completion bash)" >> ${HOME}/.bashrc
echo "source <(kubeadm completion bash)" >> ${HOME}/.bashrc
echo "source <(kubectl completion bash)" | sudo tee -a /root/.bashrc
echo "source <(kubeadm completion bash)" | sudo tee -a /root/.bashrc
source ${HOME}/.bashrc

# deploy k8s
ansible-playbook -l k8s-cluster playbooks/k8s-cluster.yml -K


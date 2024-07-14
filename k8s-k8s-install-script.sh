#!/bin/bash

#enable IP forwarding on all nodes
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p

#Turn off swap.
sudo free -m
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo mount -a

sudo rm -rf /swap.img	


#its preapare for ubuntu to instal k8s.

======Fresh from kubernetes sources all nodes ============
#1. Update the apt package index and install packages needed to use the Kubernetes apt repository:

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl

#2. Download the Google Cloud public signing key:

    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#3. Add the Kubernetes apt repository:

    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#4. Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it 
=================================
-----https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/------


#only in master
#sudo kubeadm init --dry-run

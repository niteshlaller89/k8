#!/bin/bash
#swap off for kubernetes
free -h
sudo swapoff -a
sudo vi /etc/fstab

#install cre (docker)
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
sudo usermod -aG docker barco

#install kubernetes
sudo apt-get update && sudo apt-get install -y vim bash-completion apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash >/etc/bash_completion.d/kubectl
source ~/.bashrc
#setup k8 master node
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#create calico
kubectl create -f calico.yaml

#for nodes join the cluster

##install helm
# curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
# sudo apt-get install apt-transport-https --yes
# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
# sudo apt-get update
# sudo apt-get install helm

##install kubeapps

## Create Persistent Volume
## create /mnt/data directory for persistent storage on all nodes 
## create /mnt/data/index.html
## sudo mkdir /mnt/data
## sudo sh -c "echo 'Hello from Kubernetes storage' > /mnt/data/index.html"




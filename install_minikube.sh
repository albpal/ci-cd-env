#!/bin/bash

yum update
yum install -y yum-utils device-mapper-persistent-data lvm2 curl
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
install minikube /usr/local/sbin
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install kubectl xdg-utils xauth xclock -y
systemctl stop kubepods-burstable.slice
sysctl -w net.bridge.bridge-nf-call-iptables=1
$(dirname $0)/start_minikube.sh
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
sleep 60
kubectl patch deployment coredns -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"apalau/updated-at\":\"$(date +%s)\"}}}}}" -n kube-system
sleep 60

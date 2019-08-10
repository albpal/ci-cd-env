#!/bin/bash

echo "*** ATENTION PLEASE! THIS SCRIPT WILL RESTART YOUR MACHINE *** ARE YOU SURE YOU WANT TO CONTINUE?"
echo -n "yes / no: "
read s
if [ "$s" != "yes" ];then
	exit 0
fi
if [ "$(id -un)" != "root" ];then
	echo "Execute this script as root"
	exit 1
fi

minikube stop
minikube delete
systemctl stop kubelet
kubeadm reset -f
yum remove kubectl -y
rm -f /usr/lib/systemd/system/kubelet.service
systemctl daemon-reload
systemctl reset-failed
rm -rf /var/lib/minikube /etc/kubernetes /root/.kube /root/.minikube /var/run/dockershim.sock /data/minikube
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker
shutdown -r now

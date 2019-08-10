#!/bin/bash

yum update
yum install kubectl -y
systemctl stop kubepods-burstable.slice
sysctl -w net.bridge.bridge-nf-call-iptables=1
$(dirname $0)/start_minikube.sh

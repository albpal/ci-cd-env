#!/bin/bash

minikube start --vm-driver=none --extra-config=apiserver.authorization-mode=RBAC --feature-gates=HugePages=true

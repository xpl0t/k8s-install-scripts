#!/bin/bash

# Always load overlay & br_netfilter kernel modules
echo "Install flannel CNI plugin..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

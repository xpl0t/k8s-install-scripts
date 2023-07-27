#!/bin/bash

ARCH=amd64

while getopts v: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
    esac
done

if [ -v $VERSION ]
then
  echo "Specify a kubernetes version (-v)"
  exit 1
fi

echo "Installing kubeadm, kubelet & kubectl $VERSION...";

echo "Installing kubeadm $VERSION..."
wget -nv -O /usr/local/bin/kubeadm https://dl.k8s.io/${VERSION}/bin/linux/${ARCH}/kubeadm

echo "Installing kubelet $VERSION..."
wget -nv -O /usr/local/bin/kubelet https://dl.k8s.io/${VERSION}/bin/linux/${ARCH}/kubelet

echo "Installing kubectl $VERSION..."
wget -nv -O /usr/local/bin/kubectl https://dl.k8s.io/${VERSION}/bin/linux/${ARCH}/kubectl

RELEASE_VERSION="v0.15.1"
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service" | sed "s:/usr/bin:/usr/local/bin:g" | tee /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf" | sed "s:/usr/bin:/usr/local/bin:g" | tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable --now kubelet

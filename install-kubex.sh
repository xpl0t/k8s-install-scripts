#!/bin/bash

VERSION="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
RELEASE_VERSION="v0.16.2"
ARCH="amd64"

while getopts v:r: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
	r) RELEASE_VERSION=${OPTARG};;
    esac
done

echo "Installing kubeadm, kubelet & kubectl $VERSION...";

echo "Installing kubeadm $VERSION..."
wget -nv -O /usr/local/bin/kubeadm https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubeadm
chmod +x /usr/local/bin/kubeadm

echo "Installing kubelet $VERSION..."
wget -nv -O /usr/local/bin/kubelet https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubelet
chmod +x /usr/local/bin/kubelet

echo "Installing kubectl $VERSION..."
wget -nv -O /usr/local/bin/kubectl https://dl.k8s.io/release/${VERSION}/bin/linux/${ARCH}/kubectl
chmod +x /usr/local/bin/kubectl

curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/krel/templates/latest/kubelet/kubelet.service" | sed "s:/usr/bin:/usr/local/bin:g" | sudo tee /etc/systemd/system/kubelet.service
sudo mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/krel/templates/latest/kubeadm/10-kubeadm.conf" | sed "s:/usr/bin:/usr/local/bin:g" | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable --now kubelet

#!/bin/bash

set -e

ARCH="amd64"

# Install binaries
CONTAINERD_ARCHIVE="/tmp/containerd.tar.gz"

echo Installing containerd binaries...
mkdir -p /tmp
wget -nv -O ${CONTAINERD_ARCHIVE} https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-${ARCH}.tar.gz

tar Cxzvf /usr/local ${CONTAINERD_ARCHIVE}

# Writing containerd base config
echo Writing containerd base config
mkdir -p /etc/containerd
containerd config default | sed "s/SystemdCgroup = false/SystemdCgroup = true/g" > /etc/containerd/config.toml

# Install containerd systemd service
echo Installing containerd systemd service...
wget -nv -O /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

# Install runc
RUNC_BIN="/tmp/runc"

echo Installing runc...
wget -nv -O ${RUNC_BIN} https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.${ARCH}
install -m 755 ${RUNC_BIN} /usr/local/sbin/runc

# Install CNI plugins
CNI_ARCHIVE="/tmp/cni.tar.gz"

echo Installing CNI plugins...
wget -nv -O ${CNI_ARCHIVE} https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-${ARCH}-v1.3.0.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin ${CNI_ARCHIVE}

# Install crictl
CRICTL_ARCHIVE="/tmp/crictl.tar.gz"
CRICTL_VERSION="v1.27.0"

echo Installing crictl...
wget -nv -O ${CRICTL_ARCHIVE} https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz
tar Cxzvf /tmp ${CRICTL_ARCHIVE}
install -m 755 /tmp/crictl /usr/local/sbin/crictl
echo "CONTAINER_RUNTIME_ENDPOINT=unix:///run/containerd/containerd.sock" | tee -a /etc/environment

# Install nerdctl
NERDCTL_ARCHIVE="/tmp/nerdctl.tar.gz"

echo Installing nerdctl...
wget -nv -O ${NERDCTL_ARCHIVE} https://github.com/containerd/nerdctl/releases/download/v1.4.0/nerdctl-1.4.0-linux-${ARCH}.tar.gz
tar Cxzvf /tmp ${NERDCTL_ARCHIVE}
install -m 755 /tmp/nerdctl /usr/local/sbin/nerdctl

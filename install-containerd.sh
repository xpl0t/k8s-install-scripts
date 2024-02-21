#!/bin/bash

set -e

ARCH="amd64"
CONTAINERD_VERSION="1.7.13"
RUNC_VERSION="1.1.12"
CNI_PLUGINS_VERSION="1.4.0"
CRICTL_VERSION="1.29.0"
NERDCTL_VERSION="1.7.4"

# Install binaries
CONTAINERD_ARCHIVE="/tmp/containerd.tar.gz"

echo Installing containerd binaries...
mkdir -p /tmp
wget -nv -O ${CONTAINERD_ARCHIVE} https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-${ARCH}.tar.gz

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
wget -nv -O ${RUNC_BIN} https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.${ARCH}
install -m 755 ${RUNC_BIN} /usr/local/sbin/runc

# Install CNI plugins
CNI_ARCHIVE="/tmp/cni.tar.gz"

echo Installing CNI plugins...
wget -nv -O ${CNI_ARCHIVE} https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-${ARCH}-v${CNI_PLUGINS_VERSION}.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin ${CNI_ARCHIVE}

# Install crictl
CRICTL_ARCHIVE="/tmp/crictl.tar.gz"

echo Installing crictl...
wget -nv -O ${CRICTL_ARCHIVE} https://github.com/kubernetes-sigs/cri-tools/releases/download/v${CRICTL_VERSION}/crictl-v${CRICTL_VERSION}-linux-${ARCH}.tar.gz
tar Cxzvf /tmp ${CRICTL_ARCHIVE}
install -m 755 /tmp/crictl /usr/local/sbin/crictl
echo "CONTAINER_RUNTIME_ENDPOINT=unix:///run/containerd/containerd.sock" | tee -a /etc/environment

# Install nerdctl
NERDCTL_ARCHIVE="/tmp/nerdctl.tar.gz"

echo Installing nerdctl...
wget -nv -O ${NERDCTL_ARCHIVE} https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-${ARCH}.tar.gz
tar Cxzvf /tmp ${NERDCTL_ARCHIVE}
install -m 755 /tmp/nerdctl /usr/local/sbin/nerdctl

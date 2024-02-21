# K8s install scripts

Collection of scripts to install kubernetes on any linux distro with kubeadm.

## Install Instroductions

1. Run `./install-common-YOUR_ARCHITECTURE.sh`
2. Run `./disable-swap.sh`
3. Run `./setup-netbase.sh`

   Optionally run `./check-netbase.sh`
4. Run `./install-nettools-YOUR_ARCHITECTURE.sh`
5. Run `./install-containerd.sh`
6. Run `./install-kubex.sh`
7. Setup kubernetes config with kubeadm
   
   For master nodes run `kubeadm init`

   **Example:** `kubeadm init --control-plane-endpoint 123.123.12.1 --pod-network-cidr 10.244.0.0/16`

   For worker node run `kubeadm join`

8. Run `./setup-kubectl-alias.sh`
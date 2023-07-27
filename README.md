# K8s install scripts

Collection of scripts to install kubernetes on any linux distro with kubeadm.

## Install Instroductions

1. Run `./disable-swap.sh`
2. Run `./setup-netbase.sh`
3. Run `./install-nettools-YOUR_ARCHITECTURE.sh`
4. Run `./install-containerd.sh`
5. Run `./install-kubex.sh`
6. Setup kubernetes config with kubeadm
   
   For master nodes run `kubeadm init`

   **Example:** `kubeadm init --control-plane-endpoint 185.207.104.55 --pod-network-cidr 10.244.0.0/16`

   For worker node run `kubeadm join`

7. Run `./setup-kubectl-alias.sh`
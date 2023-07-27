#!/bin/bash

# Always load overlay & br_netfilter kernel modules
echo "Setting up k alias for kubectl"
echo "alias k=kubectl" >> /home/${USER}/.bashrc

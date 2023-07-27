#!/bin/bash

# Install socat & conntrack
echo "Installing socat & conntrack..."
apt update
apt install -y socat conntrack

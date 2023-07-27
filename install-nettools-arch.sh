#!/bin/bash

# Install socat & conntrack
echo "Installing socat & conntrack..."
pacman -Syu
pacman -Sy socat conntrack

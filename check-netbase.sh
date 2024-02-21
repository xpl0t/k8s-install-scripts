#!/bin/bash

if ! lsmod | grep -q overlay; then
  echo "Kernel module 'overlay' not loaded" 1>&2
  exit 1
fi

if ! lsmod | grep -q br_netfilter; then
  echo "Kernel module 'br_netfilter' not loaded" 1>&2
  exit 1
fi

if ! sysctl net.bridge.bridge-nf-call-iptables | grep -q "= 1"; then
  echo "Sysctl param 'net.bridge.bridge-nf-call-iptables' not activated" 1>&2
  exit 1
fi

if ! sysctl net.bridge.bridge-nf-call-ip6tables | grep -q "= 1"; then
  echo "Sysctl param 'net.bridge.bridge-nf-call-ip6tables' not activated" 1>&2
  exit 1
fi

if ! sysctl net.ipv4.ip_forward | grep -q "= 1"; then
  echo "Sysctl param 'net.ipv4.ip_forward' not activated" 1>&2
  exit 1
fi

echo "Netbase seems fine :)"

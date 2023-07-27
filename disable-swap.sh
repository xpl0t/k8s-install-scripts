#!/bin/bash

echo Removing swap entries from /etc/fstab ...
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo Disabling swap for the current session...
swapoff -a

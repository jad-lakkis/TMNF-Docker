#!/bin/bash

# Fix GPU device permissions at startup
chmod 666 /dev/dri/renderD135 2>/dev/null || true
chmod 666 /dev/dri/card8 2>/dev/null || true
chmod 666 /dev/nvidia* 2>/dev/null || true

# Setup SSH
mkdir -p /root/.ssh
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
service ssh start

sleep infinity

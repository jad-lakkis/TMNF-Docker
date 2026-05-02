#!/bin/bash

# Fix permissions
chmod 666 /dev/dri/* 2>/dev/null || true

# Setup SSH
mkdir -p /root/.ssh
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
service ssh start

# Run the original entrypoint as wineuser
su - wineuser -c "/etc/base-entrypoint.sh bash"

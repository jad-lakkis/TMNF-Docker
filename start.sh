#!/bin/bash

# Clean X locks as root before wineuser tries
rm -f /tmp/.X0-lock 2>/dev/null || true
rm -f /tmp/.X11-unix/X0 2>/dev/null || true
chmod 1777 /tmp/.X11-unix

# Fix GPU permissions
chmod 666 /dev/dri/* 2>/dev/null || true

# Setup SSH
mkdir -p /root/.ssh
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
service ssh start

# Run original entrypoint as wineuser
su - wineuser -c "/etc/base-entrypoint.sh bash"

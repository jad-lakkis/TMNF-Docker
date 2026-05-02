#!/bin/bash

# Clean X locks
rm -f /tmp/.X0-lock 2>/dev/null || true
rm -f /tmp/.X11-unix/X0 2>/dev/null || true
pkill Xvfb 2>/dev/null || true
pkill fluxbox 2>/dev/null || true
sleep 1

# Fix GPU permissions
chmod 666 /dev/dri/* 2>/dev/null || true

# Setup SSH
mkdir -p /root/.ssh
echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
service ssh start

# Start X server as wineuser
su - wineuser -c "Xvfb :0 -ac -screen 0 1920x1200x24 -dpi 72 +extension RANDR +extension GLX +iglx +extension MIT-SHM +render -nolisten tcp -noreset -shmem &"
sleep 3

# Start fluxbox as wineuser
su - wineuser -c "DISPLAY=:0 nohup fluxbox >/dev/null 2>&1 &"
sleep 1

echo "Session Running."

# Keep container alive
sleep infinity

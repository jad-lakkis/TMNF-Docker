#!/bin/bash

# Clean stale X locks
rm -f /tmp/.X0-lock /tmp/.X1-lock 2>/dev/null || true
rm -f /tmp/.X11-unix/X0 /tmp/.X11-unix/X1 2>/dev/null || true
chmod 1777 /tmp/.X11-unix

# Kill any leftover X servers
pkill Xvfb 2>/dev/null || true
pkill fluxbox 2>/dev/null || true
sleep 1

# Try to fix GPU device permissions (best effort)
chmod 666 /dev/dri/* 2>/dev/null || true
chmod 666 /dev/nvidia* 2>/dev/null || true

# Setup SSH (RunPod injects $PUBLIC_KEY automatically from your account)
mkdir -p /root/.ssh
if [ -n "$PUBLIC_KEY" ]; then
    echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
fi
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true
service ssh start

# Start Xvfb on :0 as wineuser (for the game display)
su - wineuser -c "Xvfb :0 -ac -screen 0 1920x1200x24 -dpi 72 +extension RANDR +extension GLX +iglx +extension MIT-SHM +render -nolisten tcp -noreset -shmem" &
sleep 3

# Start fluxbox on :0
su - wineuser -c "DISPLAY=:0 nohup fluxbox >/dev/null 2>&1 &"
sleep 1

# Start VNC server on :0 (port 5900)
su - wineuser -c "x11vnc -display :0 -rfbauth /home/wineuser/.vnc/passwd -forever -shared -bg" &

echo "============================================"
echo "  TMNF + Linesight RunPod container ready"
echo "  - SSH:     port 22"
echo "  - VNC :0:  port 5900 (game display)"
echo "  - VNC :1:  port 5901 (linesight setup)"
echo "  - TB:      port 6006 (tensorboard)"
echo "  VNC password: mypasswd"
echo "============================================"

# Keep container alive
sleep infinity

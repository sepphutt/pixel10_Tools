#!/bin/bash

# Create log directory
mkdir -p /var/log/supervisor

# Set user password from environment variable
if [ -n "$USER" ] && [ -n "$PASSWORD" ]; then
    echo "$USER:$PASSWORD" | chpasswd
    echo "User password set for: $USER"
fi

# Set root password from environment variable
if [ -n "$PASSWORD" ]; then
    echo "root:$PASSWORD" | chpasswd
    echo "Root password set"
fi

# Set VNC password for user
if [ -n "$USER" ] && [ -n "$VNC_PASSWORD" ]; then
    mkdir -p /home/$USER/.vnc
    echo "$VNC_PASSWORD" | vncpasswd -f > /home/$USER/.vnc/passwd
    chmod 600 /home/$USER/.vnc/passwd
    chown -R $USER:$USER /home/$USER/.vnc
    echo "VNC password set for: $USER"
fi

# Start D-Bus
service dbus start

# Start supervisor which will manage SSH, VNC, and noVNC
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

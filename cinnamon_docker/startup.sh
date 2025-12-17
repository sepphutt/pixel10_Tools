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

# Setup VNC for user
if [ -n "$USER" ]; then
    # Create the new TigerVNC config directory
    mkdir -p /home/$USER/.config/tigervnc
    
    # Create xstartup in the new location
    cat > /home/$USER/.config/tigervnc/xstartup << 'XSTARTUP_EOF'
#!/bin/bash
export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export CINNAMON_SOFTWARE_RENDERING=1
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe
export XDG_SESSION_DESKTOP=cinnamon
export XDG_CURRENT_DESKTOP=X-Cinnamon
export DESKTOP_SESSION=cinnamon
export XDG_SESSION_TYPE=x11
export DISPLAY=:1
# Disable Mutter GPU acceleration
export MUTTER_DEBUG_ENABLE_ATOMIC_KMS=0
export MUTTER_DEBUG_FORCE_KMS_MODE=simple
# Start D-Bus session
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi
# Start Cinnamon session
exec cinnamon-session
XSTARTUP_EOF
    chmod +x /home/$USER/.config/tigervnc/xstartup
    
    # Create .Xauthority file
    touch /home/$USER/.Xauthority
    chmod 600 /home/$USER/.Xauthority
    
    # Set correct ownership
    chown -R $USER:$USER /home/$USER/.config
    chown $USER:$USER /home/$USER/.Xauthority
    echo "VNC configured for: $USER (no password required)"
fi

# CleanUp Update
apt-get clean && rm -rf /var/lib/apt/lists/*

# Start D-Bus
service dbus start

# Start supervisor which will manage SSH, VNC, and noVNC
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

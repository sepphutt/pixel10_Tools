#!/usr/bin/env bash
set -euo pipefail

# === Konfiguration (am Anfang anpassen) ===
DEFAULT_PASS="pixel10"
VNC_DISPLAY=":1"
VNC_PORT=5901
VNC_GEOMETRY="1280x720"
NOVNC_PORT=6080
KEYBOARD_LAYOUT="at"
KEYBOARD_VARIANT=""
# =========================================

USER_NAME="$(whoami)"
ARCH="$(dpkg --print-architecture)"

echo "Installiere für User: $USER_NAME (Arch: $ARCH)"

sudo timedatectl set-ntp true
sudo rm -rf /var/lib/apt/lists/*
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo sed -i 's|http://.*debian.org|http://deb.debian.org|g' /etc/apt/sources.list
sudo apt update

# Cinnamon Desktop und alle Tools/Abhängigkeiten
echo "Installiere Cinnamon Desktop und alle Abhängigkeiten..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  task-cinnamon-desktop \
  dbus-x11 \
  xauth \
  xinit \
  x11-xserver-utils \
  tigervnc-standalone-server \
  tigervnc-common \
  git \
  python3-pip \
  python3-websockify \
  wget \
  curl \
  ca-certificates \
  keyboard-configuration \
  console-setup \
  sudo \
  supervisor \
  net-tools \
  iproute2 \
  vim \
  xterm \
  gnome-terminal \
  nemo \
  firefox-esr \
  pulseaudio \
  pavucontrol \
  mesa-utils \
  libgl1-mesa-dri \
  libgl1 \
  x11-apps \
  fonts-noto \
  fonts-dejavu \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  eog \
  gthumb \
  file-roller \
  gvfs \
  gvfs-backends \
  xclip \
  apt-transport-https \
  gnupg2 \
  software-properties-common
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# VS Code installieren
echo "Installiere Visual Studio Code..."
# Entferne alte/doppelte Einträge
sudo rm -f /etc/apt/sources.list.d/vscode.list
sudo rm -f /etc/apt/trusted.gpg.d/microsoft.gpg 2>/dev/null || true
# Füge Repository hinzu
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-vscode.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  code \
  libx11-6 \
  libx11-xcb1 \
  libxss1 \
  libasound2 \
  libgtk-3-0 \
  libnotify4 \
  libnss3 \
  libxkbfile1 \
  libsecret-1-0 || true
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Microsoft Edge installieren
echo "Installiere Microsoft Edge..."

# Füge Repository hinzu
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y microsoft-edge-stable || true
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Keyboard Layout auf German Austria setzen
echo "Konfiguriere Keyboard Layout: German Austria"
sudo bash -c "cat > /etc/default/keyboard <<EOF
XKBMODEL=\"pc105\"
XKBLAYOUT=\"${KEYBOARD_LAYOUT}\"
XKBVARIANT=\"${KEYBOARD_VARIANT}\"
XKBOPTIONS=\"\"
BACKSPACE=\"guess\"
EOF"
sudo dpkg-reconfigure -f noninteractive keyboard-configuration
sudo setupcon || echo "setupcon konnte nicht ausgeführt werden (wird bei nächstem Login aktiv)"

# Locale und X11 Konfiguration für Keysym-Probleme
echo "Konfiguriere Locale und X11..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y locales
sudo sed -i '/de_AT.UTF-8/s/^# //g' /etc/locale.gen || true
sudo sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen || true
sudo locale-gen
sudo update-locale LANG=de_AT.UTF-8 LC_ALL=de_AT.UTF-8

# websockify via apt statt pip (vermeidet "externally managed environment" Fehler)
# Debian/Ubuntu hat python3-websockify als Paket - das ist besser als pip in Debian 12+
echo "Installiere websockify..."
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-websockify python3-numpy || true
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# VNC Passwort für aktuellen User setzen
sudo -u "$USER_NAME" bash -c "mkdir -p ~/.vnc && printf '%s\n%s\n\n' \"$DEFAULT_PASS\" \"$DEFAULT_PASS\" | vncpasswd"

# .Xresources für bessere Keysym-Unterstützung
sudo -u "$USER_NAME" bash -c 'cat > ~/.Xresources <<EOF
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.hintstyle: hintslight
EOF'

# xstartup für Cinnamon
sudo -u "$USER_NAME" bash -c 'cat > ~/.vnc/xstartup <<EOF
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# X Resources laden
test -r ~/.Xresources && xrdb -merge ~/.Xresources

# Locale setzen
export LANG=de_AT.UTF-8
export LC_ALL=de_AT.UTF-8

exec /usr/bin/cinnamon-session &>/dev/null
EOF
chmod +x ~/.vnc/xstartup'

# Systemd service für TigerVNC (per-user)
SERVICE_PATH="/etc/systemd/system/vncserver@.service"
sudo bash -c "cat > \$SERVICE_PATH <<EOF
[Unit]
Description=TigerVNC server for %i
After=network.target

[Service]
Type=forking
User=%i
PAMName=login
PIDFile=/home/%i/.vnc/%H:1.pid
ExecStart=/usr/bin/vncserver :1 -geometry ${VNC_GEOMETRY} -localhost no
ExecStop=/usr/bin/vncserver -kill :1
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl enable vncserver@"${USER_NAME}".service
sudo systemctl start vncserver@"${USER_NAME}".service

# Install noVNC
sudo mkdir -p /opt/novnc
sudo chown "$USER_NAME":"$USER_NAME" /opt/novnc
sudo -u "$USER_NAME" git clone https://github.com/novnc/noVNC.git /opt/novnc || true
sudo -u "$USER_NAME" git -C /opt/novnc pull || true
# websockify is provided by pip (python3-websockify or pip install websockify)

# Systemd service for noVNC (websockify)
NOVNC_SERVICE="/etc/systemd/system/novnc.service"
sudo bash -c "cat > \$NOVNC_SERVICE <<EOF
[Unit]
Description=noVNC websockify
After=network.target vncserver@${USER_NAME}.service

[Service]
Type=simple
User=${USER_NAME}
WorkingDirectory=/opt/novnc
ExecStart=/usr/bin/python3 -m websockify --web /opt/novnc ${NOVNC_PORT} localhost:${VNC_PORT}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload

# Stoppe Services falls sie laufen (bei Re-Installation)
sudo systemctl stop vncserver@"${USER_NAME}".service 2>/dev/null || true
sudo systemctl stop novnc.service 2>/dev/null || true

# Aktiviere und starte Services
sudo systemctl enable vncserver@"${USER_NAME}".service
sudo systemctl start vncserver@"${USER_NAME}".service

# Warte kurz damit VNC Server bereit ist
sleep 2

sudo systemctl enable novnc.service
sudo systemctl start novnc.service

sudo apt autoremove -y
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Status ausgeben
echo ""
echo "========================================"
echo "Installation abgeschlossen!"
echo "========================================"
echo "Öffne im Browser: http://$(hostname -I | awk '{print $1}'):${NOVNC_PORT}/vnc.html"
echo "VNC Display: ${VNC_DISPLAY} (VNC-Port ${VNC_PORT})"
echo "Passwort: ${DEFAULT_PASS}"
echo "Keyboard Layout: German Austria"
echo ""
echo "Service Status:"
sudo systemctl status vncserver@"${USER_NAME}".service --no-pager -l || true
sudo systemctl status novnc.service --no-pager -l || true
FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=docker

# Install utilities and Cinnamon essentials
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo \
    wget \
    curl \
    git \
    supervisor \
    net-tools \
    iproute2 \
    vim \
    nano \
    xterm \
    gnome-terminal \
    nemo \
    nemo-fileroller \
    firefox-esr \
    pulseaudio \
    pavucontrol \
    mesa-utils \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgl1 \
    x11-apps \
    x11-xserver-utils \
    xauth \
    xinit \
    fonts-noto \
    fonts-noto-color-emoji \
    fonts-dejavu \
    fonts-liberation \
    fonts-liberation2 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-alsa \
    gstreamer1.0-pulseaudio \
    eog \
    gthumb \
    file-roller \
    gvfs \
    gvfs-backends \
    gvfs-fuse \
    xclip \
    xdg-utils \
    xdg-user-dirs \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    dconf-editor \
    cinnamon-control-center \
    cinnamon-screensaver \
    cinnamon-settings-daemon \
    cinnamon-session \
    gnome-calculator \
    gnome-system-monitor \
    gedit \
    pluma \
    atril \
    engrampa \
    mate-themes \
    muffin \
    nemo-preview \
    blueberry \
    network-manager-gnome \
    adwaita-icon-theme \
    breeze-icon-theme \
    papirus-icon-theme \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Cinnamon desktop environment
RUN apt-get update && apt-get install -y \
    cinnamon-desktop-environment \
    cinnamon-core \
    lightdm \
    dbus-x11 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install VNC server
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install noVNC and websockify
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-numpy && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Create user (password will be set at runtime)
RUN useradd -m -s /bin/bash -G sudo ${USER}

# Configure VNC
RUN mkdir -p /home/${USER}/.vnc && \
    chmod 700 /home/${USER}/.vnc && \
    chown -R ${USER}:${USER} /home/${USER}/.vnc

# Create VNC xstartup script
RUN echo '#!/bin/bash\n\
export XKL_XMODMAP_DISABLE=1\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
exec cinnamon-session' > /home/${USER}/.vnc/xstartup && \
    chmod +x /home/${USER}/.vnc/xstartup && \
    chown ${USER}:${USER} /home/${USER}/.vnc/xstartup

# Install Visual Studio Code (GUI) and additional GUI libs
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get update && apt-get install -y \
        code \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        libasound2 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libatspi2.0-0 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libdrm2 \
        libgbm1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libnotify4 \
        libxkbfile1 \
        libsecret-1-0 \
        libgconf-2-4 \
        libexpat1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Microsoft Edge Browser
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft-edge.gpg && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list' && \
    apt-get update && apt-get install -y \
        microsoft-edge-stable \
        fonts-liberation \
        libu2f-udev \
        libvulkan1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose ports
EXPOSE 22 5901 6080

CMD ["/startup.sh"]

FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=docker

# Install basic utilities
RUN apt-get update && apt-get install -y \
    software-properties-common \
    sudo \
    wget \
    curl \
    git \
    supervisor \
    net-tools \
    vim \
    xterm

# Install SSH server
RUN apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install Cinnamon desktop environment
RUN apt-get install -y \
    cinnamon-desktop-environment \
    cinnamon-core \
    lightdm \
    dbus-x11

# Install VNC server
RUN apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common

# Install noVNC and websockify
RUN apt-get install -y \
    python3 \
    python3-pip \
    python3-numpy && \
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
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg || true && \
        sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
        apt-get update && apt-get install -y --no-install-recommends \
            code \
            libx11-6 \
            libx11-xcb1 \
            libxss1 \
            libasound2 \
            libgtk-3-0 \
            libnotify4 \
            libnss3 \
            libxkbfile1 \
            libsecret-1-0 || true && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose ports
EXPOSE 22 5901 6080

CMD ["/startup.sh"]

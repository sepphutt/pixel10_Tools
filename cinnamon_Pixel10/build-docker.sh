#!/bin/bash

# Docker installation script for Debian-based systems
# Checks and installs all required dependencies and Docker Engine

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Docker installation for Debian/Ubuntu ===${NC}\n"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (sudo ./build-docker.sh)${NC}"
    exit 1
fi

# Function to check if a package is installed
check_package() {
    if dpkg -l | grep -q "^ii  $1 "; then
        echo -e "${GREEN}✓${NC} $1 is already installed"
        return 0
    else
        echo -e "${YELLOW}○${NC} $1 is missing - will be installed"
        return 1
    fi
}

# Function to check if a command exists
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is available"
        return 0
    else
        echo -e "${YELLOW}○${NC} $1 is missing"
        return 1
    fi
}

echo "=== System update ==="
apt-get update
echo -e "${GREEN}✓ System updated${NC}\n"

echo "=== Check and install base dependencies ==="
REQUIRED_PACKAGES=(
    "ca-certificates"
    "curl"
    "gnupg"
    "lsb-release"
    "apt-transport-https"
    "software-properties-common"
)

PACKAGES_TO_INSTALL=()

for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! check_package "$package"; then
        PACKAGES_TO_INSTALL+=("$package")
    fi
done

if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo -e "\n${YELLOW}Installing missing packages: ${PACKAGES_TO_INSTALL[*]}${NC}"
    apt-get install -y "${PACKAGES_TO_INSTALL[@]}"
    echo -e "${GREEN}✓ All base dependencies installed${NC}\n"
else
    echo -e "${GREEN}✓ All base dependencies already installed${NC}\n"
fi

echo "=== Check Docker installation ==="
if check_command "docker"; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}Docker is already installed: $DOCKER_VERSION${NC}"
    read -p "Do you want to reinstall/update Docker? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Removing old Docker versions..."
    apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
fi

echo -e "\n=== Remove old Docker versions (if any) ==="
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
echo -e "${GREEN}✓ Old versions removed${NC}\n"

echo "=== Add Docker GPG key ==="
install -m 0755 -d /etc/apt/keyrings
if [ -f /etc/apt/keyrings/docker.gpg ]; then
    rm /etc/apt/keyrings/docker.gpg
fi
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo -e "${GREEN}✓ GPG key added${NC}\n"

echo "=== Add Docker repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
echo -e "${GREEN}✓ Docker repository added${NC}\n"

echo "=== Update package lists ==="
apt-get update
echo -e "${GREEN}✓ Package lists updated${NC}\n"

echo "=== Install Docker Engine ==="
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
echo -e "${GREEN}✓ Docker Engine installed${NC}\n"

echo "=== Start Docker service ==="
systemctl start docker
systemctl enable docker
echo -e "${GREEN}✓ Docker service started and enabled${NC}\n"

echo "=== Verify Docker installation ==="
if docker --version; then
    echo -e "${GREEN}✓ Docker installed successfully${NC}"
fi

if docker compose version; then
    echo -e "${GREEN}✓ Docker Compose installed successfully${NC}"
fi

# Docker Test
echo -e "\n=== Test Docker with hello-world ==="
if docker run --rm hello-world > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker is working correctly${NC}\n"
else
    echo -e "${YELLOW}⚠ Docker test failed${NC}\n"
fi

# Add sudo user to docker group
if [ -n "$SUDO_USER" ]; then
    echo "=== Add user '$SUDO_USER' to docker group ==="
    usermod -aG docker "$SUDO_USER"
    echo -e "${GREEN}✓ User added${NC}"
    echo -e "${YELLOW}Note: Please re-login or run 'newgrp docker' to use Docker without sudo${NC}\n"
fi

echo -e "${GREEN}=== Installation completed! ===${NC}\n"
echo "Docker Version: $(docker --version)"
echo "Docker Compose Version: $(docker compose version)"
echo ""
echo "You can now start the container with 'docker compose up -d --build'"

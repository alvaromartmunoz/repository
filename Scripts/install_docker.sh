#!/bin/bash
# Verficando Permisos
sudo -l

# Ubuntu
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

# Clave GPG
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt autoremove -y

# Install Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Docker Users
name=$(whoami)
sudo usermod -aG docker $name

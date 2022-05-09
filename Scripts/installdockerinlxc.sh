#!/bin/bash
apt update && apt upgrade -y # Actualiza el sistema
apt install docker.io -y # Instala Docker
systemctl start docker # Inicia el Servicio de Docker
systemctl enable docker # Inicia los contenedores de Docker al iniciar el LXC

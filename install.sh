#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y
	sudo apt-get install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Base" off    # any option can be set to default to "on"
	         2 "BashRC ALIAS" off
	         3 "Docker" off
	         4 "Portainer" off
	         5 "Cockpit" off
	         6 "Git" off
	         7 "Generating SSH keys" off
	         8 "Container ITLandScape" off
	         9 "" off
	         10 "" off
	         11 "" off
	         12 "" off
	         13 "" off
	         14 "" off
	         15 "" off
	         16 "" off
	         17 "" off
	         18 "" off
			 19 "" off
			 20 "" off
			 21 "" off
			 22 "" off
			 23 "" off
			 24 "" off
			 25 "" off
			 26 "" off
			 27 "" off
			 28 "" off)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            apt install -y dos2unix neofetch samba curl 
				;;
	        2)
			#AGREGADO DE ALIAS Y DEMÁS
			    echo 'limpiarpantalla (){' >> /etc/bash.bashrc
				echo '        clear' >> /etc/bash.bashrc
				echo '        neofetch' >> /etc/bash.bashrc
				echo '        echo Hoy estamos a dia `date`' >> /etc/bash.bashrc
				echo '        echo "DIRECCION IP DEL SERVIDOR:" `hostname -I | awk '{print $1}'`' >> /etc/bash.bashrc
				echo '        echo "DIRECCION IP DEL SERVIDOR:" `hostname -i`' >> /etc/bash.bashrc
				echo '}' >> /etc/bash.bashrc
				echo 'limpiarpantalla' >> /etc/bash.bashrc
				echo 'alias update="sudo apt update && sudo apt upgrade"' >> /etc/bash.bashrc
				echo 'alias desbloqueardpkg="rm /var/lib/apt/lists/lock && rm /var/cache/apt/archives/lock && rm /var/lib/dpkg/lock"' >> /etc/bash.bashrc
				echo 'alias ..="cd .."' >> /etc/bash.bashrc
				echo 'alias limpiador="sudo apt-get autoremove && sudo apt-get clean"' >> /etc/bash.bashrc
				echo "setxkbmap -option grp:alt_shift_toggle es" >> ~/.bashrc
				;;
			3)
			    apt install docker.io -y # Instala Docker
				systemctl start docker # Inicia el Servicio de Docker
				systemctl enable docker # Inicia los contenedores de Docker al iniciar el LXC
				
			#Docker-compose
				apt install curl -y
				curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
				chmod +x /usr/local/bin/docker-compose

				;;
    		4)	
			#Instalar Portainer
				docker volume create portainer_data # Creara un Volumen persistente para los datos
				docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
				;;
				
			5)
				git clone https://github.com/optimans/cockpit-zfs-manager.git
				cp -r cockpit-zfs-manager/zfs /usr/share/cockpit
				wget https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.4/cockpit-navigator_0.5.4-1focal_all.deb
				apt install ./cockpit-navigator_0.5.4-1focal_all.deb
				wget https://launchpad.net/ubuntu/+source/cockpit/215-1~ubuntu19.10.1/+build/18889196/+files/cockpit-docker_215-1~ubuntu19.10.1_all.deb
				dpkg -i cockpit-docker_215-1\~ubuntu19.10.1_all.deb
				rm cockpit-docker_215-1\~ubuntu19.10.1_all.deb
				wget -O - https://raw.githubusercontent.com/enira/cockpit-smb-plugin/master/install.sh | sudo bash
				;;

			6)
			#Install git
				echo "Installing Git, please congiure git later..."
				apt install git -y
				;;
			7)
			#GENERAR CLAVES SSH
				echo "Generating SSH keys"
				ssh-keygen -t rsa -b 4096
				;;
			8)
			#INSTALAR DOCKER IMAGE DE SYSADMINLANDSCAPE
				echo "Comprobando credenciales de docker Hub"
				docker login
				echo "Descargando imagen sysadminlandscape"
				docker pull alvaro6556/sysadminlandscape:latest
				echo "Corriendo contenedor"
				docker run -it --rm -d -p 8887:80 --name itlandscape alvaro6556/sysadminlandscape:latest
				;;
			9)
				
				;;
			10)
				
				;;
			11)
				
				;;
			12)
				
				;;
			13)
			
				;;
			14)
				
				;;
	    esac
	done
fi

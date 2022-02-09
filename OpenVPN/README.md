Agregando OpenVPN en Docker 🐳
Instalacion y configuracion de una VPN privada con OpenVPN y Docker 🐳 

#Tutorial en Video: YouTube Video

Tomado de: https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md
Crea un archivo docker-compose.yaml o clona el repositorio
# Inicializa los archivos de configuracion y certificados

docker-compose run --rm openvpn ovpn_genconfig -u udp://<IP-DE-TU-SERVIDOR>
docker-compose run --rm openvpn ovpn_initpki

# Arregla tus permisos (puede no ser necesario si ya estás haciendo todo con root)

sudo chown -R $(whoami): ./openvpn-data

# Inicia el contenedor de OpenVPN

docker-compose up -d

# Puedes ver los logs de contenedor con:
 
docker-compose logs -f

# Generar un certificado de cliente

export CLIENTNAME="el_nombre_del_cliente"

# Con contraseña

docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME

# Sin contraseña

docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass

# Crea el archivo de configuración del cliente

docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

# Revoca el certificado de un cliente

# Dejando los archivos crt, key y req.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
# Borrando los correspondientes archivos crt, key y req.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove

https://bookstackmartinezmunozalvaro.duckdns.org/link/29#bkmrk-%C2%A0
 
 
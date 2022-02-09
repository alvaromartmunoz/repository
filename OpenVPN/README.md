Agregando OpenVPN en Docker 🐳
Instalacion y configuracion de una VPN privada con OpenVPN y Docker 🐳 

#Tutorial en Video: YouTube Video

Tomado de: https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md
Crea un archivo docker-compose.yaml o clona el repositorio

```yaml 
version: '2'
services:
  openvpn:
    cap_add:
     - NET_ADMIN
    image: kylemanna/openvpn
    container_name: openvpn
    ports:
     - "1194:1194/udp"
    restart: always
    volumes:
     - ./openvpn-data/conf:/etc/openvpn
```

# Inicializa los archivos de configuracion y certificados

```bash
docker-compose run --rm openvpn ovpn_genconfig -u udp://<IP-DE-TU-SERVIDOR>
docker-compose run --rm openvpn ovpn_initpki
```
# Arregla tus permisos (puede no ser necesario si ya estás haciendo todo con root)

```bash
sudo chown -R $(whoami): ./openvpn-data
```

# Inicia el contenedor de OpenVPN

```bash
docker-compose up -d
```

# Puedes ver los logs de contenedor con:
 
```bash
docker-compose logs -f
```

# Generar un certificado de cliente

```bash
export CLIENTNAME="el_nombre_del_cliente"
```

# Con contraseña

```bash
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
```

# Sin contraseña

```bash
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
```

# Crea el archivo de configuración del cliente

```bash
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

```bash
# Revoca el certificado de un cliente

docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
# Dejando los archivos crt, key y req.

# Borrando los correspondientes archivos crt, key y req.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

https://bookstackmartinezmunozalvaro.duckdns.org/link/29#bkmrk-%C2%A0
 
 
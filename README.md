[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=alvaromm6556&show_icons=true&theme=monokai)](https://github.com/anuraghazra/github-readme-stats)

# Agregando OpenVPN en Docker 🐳

Instalacion y configuracion de una VPN privada con OpenVPN y Docker 🐳

Tutorial en Video: [YouTube Video](https://www.youtube.com/watch?v=Ulew2JHUHfE&ab_channel=PeladoNerd)

##### Tomado de: [https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md](https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md)

### 🐋Codigo del docker-compose.yml

```YAML
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

- Inicializa los archivos de configuracion y certificados

```shell
docker-compose run --rm openvpn ovpn_genconfig -u udp://<IP-DE-TU-SERVIDOR>
docker-compose run --rm openvpn ovpn_initpki
```

- Arregla tus permisos (puede no ser necesario si ya estás haciendo todo con root)

```shell
sudo chown -R $(whoami): ./openvpn-data
```

- Inicia el contenedor de OpenVPN

```shell
docker-compose up -d
```

- Puedes ver los logs de contenedor con:

```shell
docker-compose logs -f
```

- Generar un certificado de cliente

```shell
export CLIENTNAME="el_nombre_del_cliente"
# con contraseña
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
# sin contraseña
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
```

- Crea el archivo de configuración del cliente

```shell
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```

- Revoca el certificado de un cliente

```shell
# Dejando los archivos crt, key y req.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
# Borrando los correspondientes archivos crt, key y req.
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove
```

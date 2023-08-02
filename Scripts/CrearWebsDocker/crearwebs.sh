#!/bin/bash

echo "CREANDO CARPETAS"

sleep 2

mkdir creardockerimagenweb
mkdir creardockerimagenweb/contenido
touch creardockerimagenweb/Dockerfile

echo "QUE NOMBRE DE IMAGEN QUIERES??"
read nombreimagen

sleep 1

echo "COPIANDO WEB"
cp -r web/* creardockerimagenweb/contenido/

cd creardockerimagenweb/

codigo_web () {
  echo 'FROM nginx' >> Dockerfile
  echo 'RUN rm -drf /usr/share/nginx/html/*' >> Dockerfile
  echo 'COPY contenido/ /usr/share/nginx/html/' >> Dockerfile
}

sleep 1

construir_imagen () {
  docker build -t $nombreimagen .
}

codigo_web
construir_imagen

while true; do
    read -p "¿QUIERES CORRER EL CONTENEDOR? [Y/N]   " yn
    case $yn in
        [Yy]* ) echo "¿QUE PUERTO QUIERES?"
		read puertoseleccionado
		docker run -it -d -p $puertoseleccionado:80 $nombreimagen
		echo "CORRIENDO CONTENEDOR..."
		docker ps -a | grep $nombreimagen 
		break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "¿QUIERES PUSHEAR LA IMAGEN? [Y/N] " yn
    case $yn in
        [Yy]* ) echo "LOGUEANDO EN DOCKER HUB"
                if grep -q 'auths": {}' ~/.docker/config.json ;
        		then sudo docker login;
        		else echo "Loggin Successfully";
		fi
		echo "¿QUE VERSION ES LA NUEVA IMAGEN?"
		read versionimagen
		sleep 1
                echo "CAMBIANDO NOMBRE A LA IMAGEN"
		sleep 1
		docker tag $nombreimagen repositorio/$nombreimagen:$versionimagen
		docker push repositorio/$nombreimagen:$versionimagen
                break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

rm -drf ../creardockerimagenweb
